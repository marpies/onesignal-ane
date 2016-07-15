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
import org.json.JSONObject;

public class GetTagsFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		final int callbackID = FREObjectUtils.getInt( args[0] );

		AIR.log( "OneSignal::getTags" );
		OneSignal.getTags( new OneSignal.GetTagsHandler() {
			@Override
			public void tagsAvailable( JSONObject jsonObject ) {
				JSONObject response = new JSONObject();
				try {
					response.put( "callbackID", callbackID );
					if( jsonObject != null ) {
						response.put( "tags", jsonObject.toString() );
					}
				} catch( Exception e ) {
					e.printStackTrace();
				}
				AIR.dispatchEvent( OneSignalEvent.TAGS_RECEIVED, response.toString() );
			}
		} );

		return null;
	}

}

