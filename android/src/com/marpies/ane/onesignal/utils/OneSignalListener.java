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

import com.onesignal.OneSignal;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

public class OneSignalListener implements OneSignal.NotificationOpenedHandler, OneSignal.IdsAvailableHandler {

	@Override
	public void notificationOpened( String message, JSONObject additionalData, boolean isActive ) {
		AIR.log( "OneSignalListener::notificationOpened" );
		AIR.log( "Message: " + message );
		AIR.log( "isActive: " + isActive );
		if( additionalData != null ) {
			AIR.log( "Has additional data" );
			Iterator<String> it = additionalData.keys();
			while( it.hasNext() ) {
				String key = it.next();
				try {
					AIR.log( "\t" + key + " -> " + additionalData.get( key ) );
				} catch( JSONException e ) {
					e.printStackTrace();
				}
			}
		} else {
			AIR.log( "No additional data" );
		}
	}

	@Override
	public void idsAvailable( String userId, String pushToken ) {
		AIR.log( "OneSignalListener::idsAvailable " + userId + " | pushToken: " + pushToken );
	}

}
