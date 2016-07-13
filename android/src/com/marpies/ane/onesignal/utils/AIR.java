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

package com.marpies.ane.onesignal.utils;

import android.util.Log;
import com.marpies.ane.onesignal.OneSignalExtensionContext;

public class AIR {

	private static final String TAG = "OneSignal";
	private static boolean mLogEnabled = false;

	private static OneSignalExtensionContext mContext;
	private static OneSignalListener mOneSignalListener;

	public static void log( String message ) {
		if( mLogEnabled ) {
			Log.i( TAG, message );
		}
	}

	public static void dispatchEvent( String eventName ) {
		dispatchEvent( eventName, "" );
	}

	public static void dispatchEvent( String eventName, String message ) {
		mContext.dispatchStatusEventAsync( eventName, message );
	}

	/**
	 *
	 *
	 * Getters / Setters
	 *
	 *
	 */

	public static OneSignalExtensionContext getContext() {
		return mContext;
	}
	public static void setContext( OneSignalExtensionContext context ) {
		mContext = context;
	}

	public static void setLogEnabled( boolean value ) {
		mLogEnabled = value;
	}

	public static OneSignalListener getOneSignalListener() {
		return mOneSignalListener;
	}
	public static void setOneSignalListener( OneSignalListener notificationHandler ) {
		AIR.mOneSignalListener = notificationHandler;
	}

}
