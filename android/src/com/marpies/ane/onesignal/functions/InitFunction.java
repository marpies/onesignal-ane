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

package com.marpies.ane.onesignal.functions;

import android.app.Activity;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.marpies.ane.onesignal.utils.AIR;
import com.marpies.ane.onesignal.utils.FREObjectUtils;
import com.marpies.ane.onesignal.utils.OneSignalListener;
import com.onesignal.OneSignal;

public class InitFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		/* Already initialized */
		if( AIR.getOneSignalListener() != null ) return null;

		// oneSignalAppID param is parsed from AndroidManifest
		// autoRegister is not applicable for Android
		boolean showLogs = FREObjectUtils.getBoolean( args[2] );

		AIR.setLogEnabled( showLogs );
		if( showLogs ) {
			OneSignal.setLogLevel( OneSignal.LOG_LEVEL.DEBUG, OneSignal.LOG_LEVEL.NONE );
		}

		OneSignalListener listener = new OneSignalListener();
		AIR.setOneSignalListener( listener );

		Activity activity = AIR.getContext().getActivity();
		AIR.log( "Initializing OneSignal" );
		OneSignal.startInit( activity ).setNotificationOpenedHandler( listener ).init();
		/* Must be added after init() */
		OneSignal.idsAvailable( listener );

		return null;
	}

}
