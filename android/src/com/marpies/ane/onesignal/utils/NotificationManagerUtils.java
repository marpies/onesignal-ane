/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.marpies.ane.onesignal.utils;

import android.app.AppOpsManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class NotificationManagerUtils {

	private static final String CHECK_OP_NO_THROW = "checkOpNoThrow";
	private static final String OP_POST_NOTIFICATION = "OP_POST_NOTIFICATION";

	public static boolean areNotificationsEnabled( Context context ) {
		AppOpsManager appOps = (AppOpsManager) context.getSystemService( Context.APP_OPS_SERVICE );
		ApplicationInfo appInfo = context.getApplicationInfo();
		String pkg = context.getApplicationContext().getPackageName();
		int uid = appInfo.uid;
		try {
			Class<?> appOpsClass = Class.forName( AppOpsManager.class.getName() );
			Method checkOpNoThrowMethod = appOpsClass.getMethod( CHECK_OP_NO_THROW, Integer.TYPE,
					Integer.TYPE, String.class );
			Field opPostNotificationValue = appOpsClass.getDeclaredField( OP_POST_NOTIFICATION );
			int value = (Integer) opPostNotificationValue.get( Integer.class );
			return ((Integer) checkOpNoThrowMethod.invoke( appOps, value, uid, pkg )
					== AppOpsManager.MODE_ALLOWED);
		} catch( ClassNotFoundException | NoSuchMethodException | NoSuchFieldException |
				InvocationTargetException | IllegalAccessException | RuntimeException e ) {
			return true;
		}
	}

	public static boolean checkPlayServices( Context context ) {
		GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
		int resultCode = apiAvailability.isGooglePlayServicesAvailable( context );
		return resultCode == ConnectionResult.SUCCESS;
	}

}
