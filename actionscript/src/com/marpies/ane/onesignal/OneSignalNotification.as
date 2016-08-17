package com.marpies.ane.onesignal {

    public class OneSignalNotification {

        private var mMessage:String;
        private var mAppActive:Boolean;
        private var mAdditionalData:Object;
        private var mHasButtons:Boolean;
        private var mActionButtons:Vector.<OneSignalNotificationButton>;
        private var mActionSelected:String;
        private var mStackedNotification:Boolean;
        private var mStackedNotifications:Vector.<OneSignalNotification>;

        /**
         * @private
         */
        public function OneSignalNotification() {
        }

        /**
         * @private
         */
        internal static function fromJSON( json:Object ):OneSignalNotification {
            var notification:OneSignalNotification = new OneSignalNotification();
            notification.mMessage = json.message;
            notification.mAppActive = (json.isActive === true) || (json.isActive == 1);
            /* Check if the notification contains multiple stacked notifications */
            if( "stacked_notifications" in json ) {
                var stackedNotifications:Array = getArrayFromJSONValue( json.stacked_notifications );
                if( stackedNotifications !== null ) {
                    notification.mStackedNotification = true;
                    notification.mStackedNotifications = fromArray( stackedNotifications );
                }
                delete json.stacked_notifications;
            }
            /* Check if the notification has buttons */
            if( "actionButtons" in json ) {
                var actionButtons:Array = getArrayFromJSONValue( json.actionButtons );
                if( actionButtons !== null ) {
                    notification.mHasButtons = true;
                    notification.mActionSelected = json.actionSelected;
                    notification.mActionButtons = OneSignalNotificationButton.fromArray( actionButtons );
                }
                delete json.actionButtons;
                delete json.actionSelected;
            }
            /* Delete these so that they do not appear in additionalData */
            delete json.message;
            delete json.isActive;
            /* Store any additional data */
            notification.mAdditionalData = json;
            return notification;
        }

        /**
         * @private
         */
        private static function fromArray( array:Array ):Vector.<OneSignalNotification> {
            var result:Vector.<OneSignalNotification> = new <OneSignalNotification>[];
            var length:int = array.length;
            for( var i:int = 0; i < length; ++i ) {
                var notification:OneSignalNotification = fromJSON( array[i] );
                result[i] = notification;
            }
            return result;
        }

        /**
         * @private
         */
        private static function getArrayFromJSONValue( value:Object ):Array {
            var result:Array = value as Array;
            if( result === null ) {
                try {
                    result = JSON.parse( value as String ) as Array;
                } catch( e:Error ) { }
            }
            return result;
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Key value pairs that were set on the notification in OneSignal dashboard.
         */
        public function get additionalData():Object {
            return mAdditionalData;
        }

        /**
         * The notification message (body).
         */
        public function get message():String {
            return mMessage;
        }

        /**
         * <code>Boolean</code> stating whether the notification is part of a group
         * and contains multiple notifications.
         *
         * @see #stackedNotifications
         */
        public function get isStackedNotification():Boolean {
            return mStackedNotification;
        }

        /**
         * List of notifications which are part of the same group.
         *
         * @see #isStackedNotification
         */
        public function get stackedNotifications():Vector.<OneSignalNotification> {
            return mStackedNotifications;
        }

        /**
         * <code>Boolean</code> stating whether the notification was received while the app is active (in foreground).
         */
        public function get isAppActive():Boolean {
            return mAppActive;
        }

        /**
         * <code>Boolean</code> stating whether the notification has action buttons.
         */
        public function get hasButtons():Boolean {
            return mHasButtons;
        }

        /**
         * List of action buttons that were set on the notification in OneSignal dashboard.
         */
        public function get actionButtons():Vector.<OneSignalNotificationButton> {
            return mActionButtons;
        }

        /**
         * Id of the action button that was tapped, or <code>__DEFAULT__</code> if the
         * notification itself was tapped, or <code>null</code> if there are no action buttons.
         */
        public function get actionSelected():String {
            return mActionSelected;
        }

    }

}
