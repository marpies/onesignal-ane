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

package com.marpies.ane.onesignal.utils;

import com.marpies.ane.onesignal.data.OneSignalEvent;
import com.onesignal.OneSignal;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class OneSignalListener implements OneSignal.NotificationOpenedHandler, OneSignal.IdsAvailableHandler {

	@Override
	public void notificationOpened( String message, JSONObject additionalData, boolean isActive ) {
		/* Response dispatched to AIR */
		JSONObject response = new JSONObject();
		AIR.log( "OneSignalListener::notificationOpened" );
		if( additionalData != null ) {
			Iterator<String> it = additionalData.keys();
			while( it.hasNext() ) {
				String key = it.next();
				try {
					/* Build response JSON from the additionalData */
					addValueForKey( response, key, additionalData.get( key ) );
				} catch( JSONException e ) {
					e.printStackTrace();
				}
			}
		}

		addValueForKey( response, "message", message );
		addValueForKey( response, "isActive", isActive );

		AIR.dispatchEvent( OneSignalEvent.NOTIFICATION_RECEIVED, response.toString() );
	}

	@Override
	public void idsAvailable( String userId, String pushToken ) {
		AIR.log( "OneSignalListener::idsAvailable " + userId + " | pushToken: " + pushToken );
		JSONObject response = new JSONObject();
		addValueForKey( response, "userId", userId );
		addValueForKey( response, "pushToken", pushToken );
		AIR.dispatchEvent( OneSignalEvent.TOKEN_RECEIVED, response.toString() );
	}

	private void addValueForKey( JSONObject json, String key, Object value ) {
		if( value != null ) {
			try {
				json.put( key, value );
			} catch( JSONException e ) {
				e.printStackTrace();
			}
		}
	}

}
