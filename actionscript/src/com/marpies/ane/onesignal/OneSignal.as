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

package com.marpies.ane.onesignal {

    import flash.desktop.NativeApplication;
    import flash.events.InvokeEvent;
    import flash.events.StatusEvent;
    import flash.external.ExtensionContext;
    import flash.system.Capabilities;
    import flash.utils.Dictionary;

    public class OneSignal {

        private static const TAG:String = "[OneSignal]";
        private static const EXTENSION_ID:String = "com.marpies.ane.onesignal";

        private static var mContext:ExtensionContext;

        /* Event codes */

        /* Misc */
        private static var mInitialized:Boolean;
        private static var mLogEnabled:Boolean;
        private static const iOS:Boolean = Capabilities.manufacturer.indexOf( "iOS" ) > -1;
        private static const ANDROID:Boolean = Capabilities.manufacturer.indexOf( "Android" ) > -1;

        /**
         * @private
         * Do not use. OneSignal is a static class.
         */
        public function OneSignal() {
            throw Error( "OneSignal is static class." );
        }

        /**
         *
         *
         * Public API
         *
         *
         */

        /**
         * Initializes extension context.
         * 
         * @param oneSignalAppID ID of the app created in the OneSignal dashboard.
         * @param autoRegister Set to <code>true</code> to register with notification server immediately after initialization.
         * @param showLogs Set to <code>true</code> to show extension log messages.
         * 
         * @return <code>true</code> if the extension context was created, <code>false</code> otherwise
         */
        public static function init( oneSignalAppID:String, autoRegister:Boolean = false, showLogs:Boolean = false ):Boolean {
            if( !isSupported ) return false;
            if( mInitialized ) return true;

            mLogEnabled = showLogs;

            /* Initialize context */
            if( !initExtensionContext() ) {
                log( "Error creating extension context for " + EXTENSION_ID );
                return false;
            }

            /* Listen for native library events */
            mContext.addEventListener( StatusEvent.STATUS, onStatus );

            /* Call init */
            mContext.call( "init", oneSignalAppID, autoRegister, showLogs );

            mInitialized = true;
            return true;
        }

        /**
         * Disposes native extension context.
         */
        public static function dispose():void {
            if( !isSupported ) return;
            validateExtensionContext();

            mContext.removeEventListener( StatusEvent.STATUS, onStatus );

            mContext.dispose();
            mContext = null;
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Version of the native OneSignal SDK.
         */
        public static function get sdkVersion():String {
            if( !isSupported ) return null;
            if( !mInitialized && !initExtensionContext() ) {
                return null;
            }

            return mContext.call( "sdkVersion" ) as String;
        }

        /**
         * Extension version.
         */
        public static function get version():String {
            return "0.0.2";
        }

        /**
         * Supported on iOS and Android.
         */
        public static function get isSupported():Boolean {
            return iOS || ANDROID;
        }

        /**
         *
         *
         * Private API
         *
         *
         */

        /**
         * Initializes extension context.
         * @return <code>true</code> if initialized successfully, <code>false</code> otherwise.
         */
        private static function initExtensionContext():Boolean {
            if( mContext === null ) {
                mContext = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
            }
            return mContext !== null;
        }

        private static function validateExtensionContext():void {
            if( !mContext ) throw new Error( "OneSignal extension was not initialized. Call init() first." );
        }

        private static function onStatus( event:StatusEvent ):void {

        }

        private static function log( message:String ):void {
            if( mLogEnabled ) {
                trace( TAG, message );
            }
        }

    }
}
