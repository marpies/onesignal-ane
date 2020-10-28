#### October 28, 2020 (v1.8.0)

* UPDATED OneSignal SDKs for both iOS (v2.15.4) and Android (v3.15.4)
* Migrated to AndroidX

#### March 11, 2020 (v1.7.0)

* UPDATED OneSignal SDKs for both iOS (v2.12.6) and Android (v3.12.6)
* ADDED Support for Android 64-bit

#### June 8, 2019 (v1.6.0)

* ADDED callback to "tags" APIs
* UPDATED "are notifications enabled" API usage (iOS)
* UPDATED iOS min version to 8.0

#### November 22, 2018 (v1.5.0)

* UPDATED OneSignal SDKs for both iOS (v2.9.3) and Android (v3.10.3)
* ADDED Firebase Messaging support libraries

#### June 19, 2018 (v1.4.1)

* FIXED conditional evaluation

#### June 18, 2018 (v1.4.0)

* UPDATED OneSignal SDKs for both iOS (v2.8.5) and Android (v3.9.1)
* ADDED new API related to user privacy
  * `setRequiresUserPrivacyConsent( value:Boolean )`
  * `provideUserConsent( value:Boolean )`
  * `get userProvidedPrivacyConsent():Boolean`
* FIXED notification click tracking
* UPDATED `isActive` notification property

#### January 20, 2018 (v1.3.0)

* UPDATED OneSignal SDKs for both iOS (v2.6.2) and Android (v3.7.1)
* ADDED `clearOneSignalNotifications` APIs
* FIXED empty notification message on Android

#### December 20, 2016 (v1.2.0)

* UPDATED OneSignal SDKs for both iOS (v2.3.4) and Android (v3.4.2)
* FIXED dispatch of notification on cold start from notification tap (iOS)

#### December 14, 2016 (v1.1.1)

* UPDATED delegate initialization on iOS
  * Fixes incorrect `areNotificationsEnabled` value before the ANE is initialized

#### September 25, 2016 (v1.1.0)

* REPLACED token available callback with `OneSignal.idsAvailable` method (see [Callbacks](#callbacks))
* UPDATED OneSignal SDKs for both iOS (v2.1.12) and Android (v3.3.0)

#### August 17, 2016 (v1.0.0)

* UPDATED OneSignal SDKs for both iOS (v2.0.9) and Android (v3.0.2)
* REMOVED `enableInAppAlertNotification` method and config parameters from `OneSignal.init` method
  Optional settings can now be configured using `OneSignal.settings` getter before initializing the extension (see [Initialization](#initialization))
* FIXED bug causing out-of-range array access if there are multiple token/notification callbacks and one of them is removed when they are triggered

#### July 20, 2016 (v0.8.0)

* Public release
