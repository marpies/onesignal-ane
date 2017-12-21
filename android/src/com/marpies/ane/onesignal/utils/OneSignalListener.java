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
import com.onesignal.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;
import java.util.List;

public class OneSignalListener implements OneSignal.NotificationOpenedHandler, OneSignal.IdsAvailableHandler, OneSignal.NotificationReceivedHandler {

	private String mUserId;
	private String mPushToken;
	private boolean mAutoRegister;

	public OneSignalListener( boolean autoRegister ) {
		mAutoRegister = autoRegister;
	}

	/**
	 *
	 *
	 * Public API
	 *
	 *
	 */

	@Override
	public void notificationOpened( OSNotificationOpenResult openedResult ) {
		AIR.log( "OneSignalListener::notificationOpened" );
		OSNotification notification = openedResult.notification;

		/* Response dispatched to AIR */
		JSONObject response = getJSONForNotification( notification );

		/* Add action buttons */
		addActionButtonsToResponse( response, notification.payload, openedResult );
		/* Add stacked notifications */
		addStackedNotificationsToResponse( response, notification );

		AIR.dispatchEvent( OneSignalEvent.NOTIFICATION_RECEIVED, response.toString() );
	}

	@Override
	public void notificationReceived( OSNotification osNotification ) {
		AIR.log( "OneSignalListener::notificationReceived | app active: " + osNotification.isAppInFocus );
		/* Notification in this handler will only be dispatched to AIR if the app is in focus,
		 * otherwise we'll wait for user interaction and the notification will be handled in 'notificationOpened' */
		if( osNotification.isAppInFocus ) {
			JSONObject response = getJSONForNotification( osNotification );
			addActionButtonsToResponse( response, osNotification.payload );
			addStackedNotificationsToResponse( response, osNotification );
			AIR.log( "Received notification while app is active, dispatching." );
			AIR.dispatchEvent( OneSignalEvent.NOTIFICATION_RECEIVED, response.toString() );
		} else {
			AIR.log( "Received notification while in background, waiting for user interaction." );
		}
	}

	@Override
	public void idsAvailable( String userId, String pushToken ) {
		AIR.log( "OneSignalListener::idsAvailable " + userId + " | pushToken: " + pushToken + " | auto dispatch: " + mAutoRegister );
		mUserId = userId;
		mPushToken = pushToken;
		/* Dispatch automatically only if autoRegister is enabled */
		if( mAutoRegister ) {
			dispatchPushToken();
		}
	}

	public void dispatchCachedPushToken() {
		AIR.log( "OneSignalListener::dispatchCachedPushToken" );
		if( !mAutoRegister && (mUserId != null || mPushToken != null) ) {
			dispatchPushToken();
		}
		/* Enable auto register so that the token is dispatched in case the SDK notifies us about token
		 * change. Also this method may be called before token is known so autoRegister must be enabled */
		mAutoRegister = true;
	}

	/**
	 *
	 *
	 * Private API
	 *
	 *
	 */

	private void addActionButtonsToResponse( JSONObject response, OSNotificationPayload payload ) {
		addActionButtonsToResponse( response, payload, null );
	}

	private void addActionButtonsToResponse( JSONObject response, OSNotificationPayload payload, OSNotificationOpenResult openedResult ) {
		List<OSNotificationPayload.ActionButton> actionButtons = payload.actionButtons;
		if( actionButtons != null ) {
			JSONArray actionButtonsJSON = new JSONArray();
			for( OSNotificationPayload.ActionButton actionButton : actionButtons ) {
				actionButtonsJSON.put( String.format(
						"{ \"id\": \"%s\", \"text\": \"%s\" }",
						actionButton.id, actionButton.text
				) );
			}
			String actionSelected = "__DEFAULT__";
			if( openedResult != null ) {
				if( openedResult.action.type == OSNotificationAction.ActionType.ActionTaken ) {
					actionSelected = openedResult.action.actionID;
				}
			}
			addValueForKey( response, "actionSelected", actionSelected );
			addValueForKey( response, "actionButtons", actionButtonsJSON );
		}
	}

	private void addStackedNotificationsToResponse( JSONObject response, OSNotification notification ) {
		List<OSNotificationPayload> groupedNotifications = notification.groupedNotifications;
		if( groupedNotifications != null ) {
			JSONArray groupedNotificationsJSON = new JSONArray();
			for( OSNotificationPayload payload : groupedNotifications ) {
				JSONObject json = getJSONForNotificationPayload( payload, notification.isAppInFocus );
				addActionButtonsToResponse( json, payload );
				groupedNotificationsJSON.put( json );
			}
			addValueForKey( response, "stacked_notifications", groupedNotificationsJSON.toString() );
		}
	}

	private JSONObject getJSONForNotification( OSNotification notification ) {
		return getJSONForNotification( notification, null );
	}

	private JSONObject getJSONForNotification( OSNotification notification, JSONObject out ) {
		JSONObject json = (out == null) ? new JSONObject() : out;
		getJSONForNotificationPayload( notification.payload, notification.isAppInFocus, json );
		return json;
	}

	private JSONObject getJSONForNotificationPayload( OSNotificationPayload payload, boolean isAppInFocus ) {
		return getJSONForNotificationPayload( payload, isAppInFocus, null );
	}

	private JSONObject getJSONForNotificationPayload( OSNotificationPayload payload, boolean isAppInFocus, JSONObject out ) {
		JSONObject json = (out == null) ? new JSONObject() : out;
        String message = (payload.body != null) ? payload.body : "";
		addValueForKey( json, "message", message );
		addValueForKey( json, "isActive", isAppInFocus );
		if( payload.title != null ) {
			addValueForKey( json, "title", payload.title );
		}
		addAdditionalDataToNotificationJSON( json, payload.additionalData );
		return json;
	}

	private void addAdditionalDataToNotificationJSON( JSONObject notificationJSON, JSONObject additionalData ) {
		if( additionalData != null ) {
			Iterator<String> it = additionalData.keys();
			while( it.hasNext() ) {
				String key = it.next();
				try {
					addValueForKey( notificationJSON, key, additionalData.get( key ) );
				} catch( JSONException e ) {
					e.printStackTrace();
				}
			}
		}
	}

	private void dispatchPushToken() {
		JSONObject response = new JSONObject();
		addValueForKey( response, "userId", mUserId );
		addValueForKey( response, "pushToken", mPushToken );
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
