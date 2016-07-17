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

import android.content.Context;
import android.content.SharedPreferences;

public class OneSignalSubscriptionManager {

	private static final String PREFERENCES_KEY = "OneSignal.preferences";
	private static final String SUBSCRIPTION_PREFERENCE_KEY = "OneSignal.subscription";

	public static void setSubscription( boolean value ) {
		SharedPreferences.Editor editor = AIR.getContext().getActivity().getSharedPreferences( PREFERENCES_KEY, Context.MODE_PRIVATE ).edit();
		editor.putBoolean( SUBSCRIPTION_PREFERENCE_KEY, value ).apply();
	}

	public static boolean getSubscription() {
		SharedPreferences prefs = AIR.getContext().getActivity().getSharedPreferences( PREFERENCES_KEY, Context.MODE_PRIVATE );
		/* Defaults to true if value has not been set */
		return prefs.getBoolean( SUBSCRIPTION_PREFERENCE_KEY, true );
	}

}
