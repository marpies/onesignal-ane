/*
 * Copyright 2016 Marcel Piestansky (http://marpies.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.marpies.ane.onesignal.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.marpies.ane.onesignal.data.OneSignalEvent;
import com.marpies.ane.onesignal.utils.AIR;
import com.marpies.ane.onesignal.utils.FREObjectUtils;
import com.onesignal.OneSignal;
import org.json.JSONException;
import org.json.JSONObject;

public class PostNotificationFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String parametersString = FREObjectUtils.getString( args[0] );
		final int callbackID = FREObjectUtils.getInt( args[1] );
		AIR.log( "OneSignal::postNotification" );

		try {
			JSONObject parameters = new JSONObject( parametersString );
			OneSignal.postNotification( parameters, new OneSignal.PostNotificationResponseHandler() {
				@Override
				public void onSuccess( JSONObject jsonObject ) {
					AIR.log( "OneSignal::postNotification | success" );
					JSONObject response = new JSONObject();
					try {
						response.put( "callbackID", callbackID );
						response.put( "successResponse", jsonObject.toString() );
						AIR.dispatchEvent( OneSignalEvent.POST_NOTIFICATION_SUCCESS, response.toString() );
					} catch( JSONException e ) {
						e.printStackTrace();
					}
				}

				@Override
				public void onFailure( JSONObject jsonObject ) {
					AIR.log( "OneSignal::postNotification | error" );
					dispatchFailure( callbackID, jsonObject );
				}
			} );
		} catch( Exception e ) {
			e.printStackTrace();
			try {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put( "error", e.getLocalizedMessage() );
				dispatchFailure( callbackID, jsonObject );
			} catch( Exception e1 ) {
				e1.printStackTrace();
			}
		}

		return null;
	}

	private void dispatchFailure( final int callbackID, JSONObject jsonObject ) {
		JSONObject response = new JSONObject();
		try {
			response.put( "callbackID", callbackID );
			response.put( "errorResponse", jsonObject.toString() );
			AIR.dispatchEvent( OneSignalEvent.POST_NOTIFICATION_ERROR, response.toString() );
		} catch( JSONException e ) {
			e.printStackTrace();
		}
	}

}

