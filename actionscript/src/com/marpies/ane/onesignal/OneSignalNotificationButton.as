package com.marpies.ane.onesignal {

    public class OneSignalNotificationButton {

        private var mId:String;
        private var mText:String;

        public function OneSignalNotificationButton() {
        }

        /**
         * @private
         */
        internal static function fromArray( array:Array ):Vector.<OneSignalNotificationButton> {
            var result:Vector.<OneSignalNotificationButton> = new <OneSignalNotificationButton>[];
            var length:int = array.length;
            for( var i:int = 0; i < length; ++i ) {
                result[i] = fromJSON( array[i] );
            }
            return result;
        }

        /**
         * @private
         */
        private static function fromJSON( json:Object ):OneSignalNotificationButton {
            var button:OneSignalNotificationButton = new OneSignalNotificationButton();
            button.mId = json.id;
            button.mText = json.text;
            return button;
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Button's id. Use it along with notification's <code>actionSelected</code>
         * to find out which button was tapped.
         *
         * @see com.marpies.ane.onesignal.OneSignalNotification#actionSelected
         */
        public function get id():String {
            return mId;
        }

        /**
         * Button's text.
         */
        public function get text():String {
            return mText;
        }

    }

}
