/**
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

package com.marpies.ane.onesignal;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.marpies.ane.onesignal.functions.*;
import com.marpies.ane.onesignal.utils.AIR;

import java.util.HashMap;
import java.util.Map;

public class OneSignalExtensionContext extends FREContext {

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

		functions.put( "init", new InitFunction() );
		functions.put( "sdkVersion", new GetSDKVersionFunction() );
		functions.put( "setSubscription", new SetSubscriptionFunction() );
		functions.put( "register", new RegisterFunction() );
		functions.put( "sendTags", new SendTagsFunction() );
		functions.put( "deleteTags", new DeleteTagsFunction() );
		functions.put( "getTags", new GetTagsFunction() );
		functions.put( "areNotificationsEnabled", new AreNotificationsEnabledFunction() );
		functions.put( "areNotificationsAvailable", new AreNotificationsAvailableFunction() );
		functions.put( "postNotification", new PostNotificationFunction() );

		return functions;
	}

	@Override
	public void dispose() {
		AIR.setContext( null );
	}
}
