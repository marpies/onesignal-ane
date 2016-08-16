package com.marpies.ane.onesignal {

    public class OneSignalSettings {

        private var mAutoRegister:Boolean;
        private var mEnableInAppAlerts:Boolean;
        private var mShowLogs:Boolean;

        /**
         * @private
         */
        public function OneSignalSettings() {
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * @private
         */
        public function get autoRegister():Boolean {
            return mAutoRegister;
        }

        /**
         * Set to <code>true</code> to register with notification server immediately after initialization.
         * If set to <code>false</code>, <code>OneSignal.register()</code> must be called later to successfully
         * register with notification servers and obtain push token to receive notifications.
         *
         * @default false
         *
         * @see com.marpies.ane.onesignal.OneSignal#register()
         */
        public function setAutoRegister( value:Boolean ):OneSignalSettings {
            mAutoRegister = value;
            return this;
        }

        /**
         * @private
         */
        public function get enableInAppAlerts():Boolean {
            return mEnableInAppAlerts;
        }

        /**
         * By default this is <code>false</code> and notifications will not be shown when the user is in your app.
         * If set to <code>true</code> notifications will be shown as native alert boxes if a notification is
         * received when the user is in your app.
         *
         * @default false
         */
        public function setEnableInAppAlerts( value:Boolean ):OneSignalSettings {
            mEnableInAppAlerts = value;
            return this;
        }

        /**
         * @private
         */
        public function get showLogs():Boolean {
            return mShowLogs;
        }

        /**
         * Set to <code>true</code> to show extension log messages.
         *
         * @default false
         */
        public function setShowLogs( value:Boolean ):OneSignalSettings {
            mShowLogs = value;
            return this;
        }

    }

}
