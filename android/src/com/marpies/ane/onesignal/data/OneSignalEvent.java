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

package com.marpies.ane.onesignal.data;

public class OneSignalEvent {

	public static final String TOKEN_RECEIVED = "tokenReceived";
	public static final String NOTIFICATION_RECEIVED = "notificationReceived";
	public static final String TAGS_RECEIVED = "tagsReceived";
    public static final String SEND_TAGS_RESPONSE = "sendTagsResponse";
	public static final String DELETE_TAGS_RESPONSE = "deleteTagsResponse";
	public static final String POST_NOTIFICATION_SUCCESS = "postNotificationSuccess";
	public static final String POST_NOTIFICATION_ERROR = "postNotificationError";

}
