# OneSignal | Native extension for Adobe AIR (iOS &amp; Android)

[OneSignal](https://onesignal.com/) is a free service that allows high volume, cross platform push notification delivery. This extension provides cross-platform API for Adobe AIR apps targeting iOS and Android.

Development of this extension is supported by [Master Tigra, Inc.](https://github.com/mastertigra)

## Features

* Receiving push notifications sent from [OneSignal dashboard](https://onesignal.com/)
* Managing user subscription
* Segmenting users using tags
* Posting notifications from device

## Native SDK versions

* iOS `v2.9.3` (Oct 29, 2018)
* Android `v3.10.3` (Nov 2, 2018)

## Requirements

* iOS 8+
* Android 4+
* Adobe AIR 29+

## Getting started

Create an app in the [OneSignal dashboard](https://onesignal.com/). Single OneSignal app can be configured for both iOS and Android.
* To support Android, follow the [tutorial on how to obtain necessary information from Google](https://documentation.onesignal.com/docs/generate-a-google-server-api-key).
* To support iOS, follow the [tutorial on how to properly setup your iOS certificates and provisioning profiles](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate).

### Additions to AIR descriptor

First, add the extension's ID to the `extensions` element.

```xml
<extensions>
    <extensionID>com.marpies.ane.onesignal</extensionID>
</extensions>
```

If you are targeting Android, add the following dependency extensions:

* `com.marpies.ane.firebase.messaging` (see the [releases page](https://github.com/marpies/onesignal-ane/releases))
* `com.distriqt.Core` (https://github.com/distriqt/ANE-Core)
* `com.distriqt.androidsupport.V4` (https://github.com/distriqt/ANE-AndroidSupport)
* `com.distriqt.playservices.Base` (https://github.com/distriqt/ANE-GooglePlayServices)
* `com.distriqt.Firebase` (https://github.com/distriqt/ANE-Firebase)

> Credits to [Distriqt](https://github.com/distriqt) for providing these and other high quality extensions.

Your app descriptor should now contain the following:

```xml
<extensions>
    <extensionID>com.marpies.ane.onesignal</extensionID>
    <extensionID>com.marpies.ane.firebase.messaging</extensionID>
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.Firebase</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>
</extensions>
```

For iOS support, look for the `iPhone` element and make sure it contains the following `InfoAdditions` and `Entitlements`:

```xml
<iPhone>
    <InfoAdditions>
        <![CDATA[
        ...

        <key>UIBackgroundModes</key>
        <array>
            <string>remote-notification</string>
        </array>

        <key>MinimumOSVersion</key>
        <string>8.0</string>
        ]]>
    </InfoAdditions>

    <Entitlements>
        <![CDATA[
            <key>aps-environment</key>
            <!-- Value below must be changed to 'production' when releasing for AppStore or Test Flight -->
            <string>development</string>
        ]]>
    </Entitlements>

    <requestedDisplayResolution>high</requestedDisplayResolution>
</iPhone>
```

For Android support, modify `manifestAdditions` element so that it contains the following:

```xml
<android>
    <manifestAdditions>
        <![CDATA[
        <manifest android:installLocation="auto">
            <!-- OneSignal permissions -->
            <permission android:name="{APP-PACKAGE-NAME}.permission.C2D_MESSAGE"
                        android:protectionLevel="signature" />
            <uses-permission android:name="{APP-PACKAGE-NAME}.permission.C2D_MESSAGE" />
            <uses-permission android:name="android.permission.INTERNET" />
            <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
            <uses-permission android:name="android.permission.WAKE_LOCK" />
            <uses-permission android:name="android.permission.VIBRATE" />
            <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
            <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

            <!-- START: ShortcutBadger -->

            <!-- Samsung -->
            <uses-permission android:name="com.sec.android.provider.badge.permission.READ"/>
            <uses-permission android:name="com.sec.android.provider.badge.permission.WRITE"/>

            <!-- HTC -->
            <uses-permission android:name="com.htc.launcher.permission.READ_SETTINGS"/>
            <uses-permission android:name="com.htc.launcher.permission.UPDATE_SHORTCUT"/>

            <!-- Sony -->
            <uses-permission android:name="com.sonyericsson.home.permission.BROADCAST_BADGE"/>
            <uses-permission android:name="com.sonymobile.home.permission.PROVIDER_INSERT_BADGE"/>

            <!-- Apex -->
            <uses-permission android:name="com.anddoes.launcher.permission.UPDATE_COUNT"/>

            <!-- Solid -->
            <uses-permission android:name="com.majeur.launcher.permission.UPDATE_BADGE"/>

            <!-- Huawei -->
            <uses-permission android:name="com.huawei.android.launcher.permission.CHANGE_BADGE" />
            <uses-permission android:name="com.huawei.android.launcher.permission.READ_SETTINGS" />
            <uses-permission android:name="com.huawei.android.launcher.permission.WRITE_SETTINGS" />

            <!-- ZUK -->
            <uses-permission android:name="android.permission.READ_APP_BADGE"/>

            <!-- OPPO -->
            <uses-permission android:name="com.oppo.launcher.permission.READ_SETTINGS"/>
            <uses-permission android:name="com.oppo.launcher.permission.WRITE_SETTINGS"/>

            <!-- EvMe -->
            <uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_READ"/>
            <uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_WRITE"/>

            <!-- End: ShortcutBadger -->

            <application>

                <meta-data android:name="com.google.android.gms.version"
                            android:value="@integer/google_play_services_version" />

                <!-- OneSignal BEGIN -->
                <meta-data android:name="onesignal_app_id"
                            android:value="{ONE-SIGNAL-APP-ID}" />
                <meta-data android:name="onesignal_google_project_number"
                            android:value="str:{GOOGLE-SENDER-ID}" />

                <receiver android:name="com.onesignal.NotificationOpenedReceiver" />
                <service android:name="com.onesignal.GcmIntentService" />

                <!-- For Android O -->
                <service android:name="com.onesignal.GcmIntentJobService"
                        android:permission="android.permission.BIND_JOB_SERVICE" />

                <service android:name="com.onesignal.SyncJobService"
                        android:permission="android.permission.BIND_JOB_SERVICE" />

                <service android:name="com.onesignal.RestoreJobService"
                    android:permission="android.permission.BIND_JOB_SERVICE" />

                <service android:name="com.onesignal.RestoreKickoffJobService"
                    android:permission="android.permission.BIND_JOB_SERVICE" />
                <!-- END - For Android O -->

                <service android:name="com.onesignal.SyncService" />
                <activity android:name="com.onesignal.PermissionsActivity"
                        android:theme="@android:style/Theme.Translucent.NoTitleBar" />

                <service android:name="com.onesignal.NotificationRestoreService" />

                <receiver android:name="com.onesignal.GcmBroadcastReceiver"
                            android:permission="com.google.android.c2dm.permission.SEND" >
                    <intent-filter>
                        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                        <category android:name="{APP-PACKAGE-NAME}" />
                    </intent-filter>
                </receiver>

                <receiver android:name="com.onesignal.BootUpReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.ACTION_BOOT_COMPLETED" />
                        <action android:name="android.intent.action.BOOT_COMPLETED" />
                        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                    </intent-filter>
                </receiver>
                <receiver android:name="com.onesignal.UpgradeReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
                    </intent-filter>
                </receiver>
                <!-- OneSignal END -->

                <!-- Firebase BEGIN -->
                <service android:name="com.google.firebase.components.ComponentDiscoveryService" >
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.analytics.connector.internal.AnalyticsConnectorRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.iid.Registrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                </service>

                <receiver
                    android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver"
                    android:exported="true"
                    android:permission="com.google.android.c2dm.permission.SEND" >
                    <intent-filter>
                        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                        <category android:name="{APP-PACKAGE-NAME}" />
                    </intent-filter>
                </receiver>

                <service
                    android:name="com.google.firebase.iid.FirebaseInstanceIdService"
                    android:exported="true" >
                    <intent-filter android:priority="-500" >
                        <action android:name="com.google.firebase.INSTANCE_ID_EVENT" />
                    </intent-filter>
                </service>
                <!-- Firebase END -->

            </application>

        </manifest>
        ]]>
    </manifestAdditions>
</android>
```

In the snippet above, replace:
* `{APP-PACKAGE-NAME}` with your app package name (value of `id` element in your AIR app descriptor). Remember it's prefixed with `air.` when packaged by AIR SDK, unless you knowingly prevent this.
* `{ONE-SIGNAL-APP-ID}` with your OneSignal app id
* `{GOOGLE-SENDER-ID}` with your Google Sender ID (also known as Google Project Number or Firebase Sender ID) obtained from [the tutorial](https://documentation.onesignal.com/docs/generate-a-google-server-api-key)

### Custom Android icons

Starting with Android 5, the OS forces the notification icon to be all white when your app targets Android API 21+. If you do not make a correct small icon, the SDK will display a notification bell icon since converting your app icon would most likely result in displaying a solid white square or circle. Therefore it is recommended you provide custom icons and repackage the extension.

You will need to create small icons in 4 sizes and replace the ones in the [android project res directory](android/com.marpies.ane.onesignal-res/):

* [mdpi](android/com.marpies.ane.onesignal-res/drawable-mdpi-v11/ic_stat_onesignal_default.png) 24x24 pixels
* [hdpi](android/com.marpies.ane.onesignal-res/drawable-hdpi-v11/ic_stat_onesignal_default.png) 36x36 pixels
* [xhdpi](android/com.marpies.ane.onesignal-res/drawable-xhdpi-v11/ic_stat_onesignal_default.png) 48x48 pixels
* [xxhdpi](android/com.marpies.ane.onesignal-res/drawable-xxhdpi-v11/ic_stat_onesignal_default.png) 72x72 pixels

The [xxhdpi directory](android/com.marpies.ane.onesignal-res/drawable-xxhdpi-v11/) also contains colorful large icon of size 192x192 pixels. This icon is displayed together with the small icon when the notification area is swiped down. You can delete the large icon, in which case only the small icon will show up.

After you replace the icons, run `ant swc android package` from the [build directory](build/) to create updated extension package, or just `ant` if you are using a Mac.

Finally, add the [OneSignal ANE](bin/com.marpies.ane.onesignal.ane) or [SWC](bin/com.marpies.ane.onesignal.swc) package from the [bin directory](bin/) to your project so that your IDE can work with it. The additional Android library ANEs are only necessary during packaging.

### API overview

#### Callbacks

To be notified when a notification is received, specify a callback method that accepts single parameter of type `OneSignalNotification`:

```as3
OneSignal.addNotificationReceivedCallback( onNotificationReceived );
...
private function onNotificationReceived( notification:OneSignalNotification ):void {
    // callback can be removed using OneSignal.removeNotificationReceivedCallback( onNotificationReceived );
    // process the notification
}
```

It is recommended to add the callback before initializing the extension to receive any notifications which result in launching your app.

You can also add a callback to be notified when user's OneSignal identifier and push notification token is available:

```as3
OneSignal.idsAvailable( onOneSignalIdsAvailable );
...
private function onOneSignalIdsAvailable( oneSignalUserId:String, pushToken:String ):void {
    // 'pushToken' may be null if there's a server or connection error
    // callback is automatically removed when 'pushToken' is delivered
}
```

#### Initialization

Before initializing OneSignal, you can set the following settings parameters:

```as3
OneSignal.settings
    .setAutoRegister( false )
    .setEnableInAppAlerts( false )
    .setShowLogs( false );
```

All these values default to `false` and changing them after the extension is initialized has no effect.

In order to comply with GDPR or other regulations, you should make sure you appropriately disclose and get consent to send data to OneSignal.

Your application should call the `setRequiresUserPrivacyConsent` method before initializing the SDK. If you pass in `true`, your application will need to call the `provideConsent` method before the OneSignal SDK gets fully initialized. Until this happens, you can continue to call other methods (such as `sendTags`), but nothing will happen.

The initialization should take place in your document class' constructor, or as early as possible after your app's launch. Replace `{ONE-SIGNAL-APP-ID}` with your OneSignal app ID:

```as3
// The SDK will delay initialization
OneSignal.setRequiresUserPrivacyConsent( true );
if( OneSignal.init( "{ONE-SIGNAL-APP-ID}" ) ) {
    // successfully initialized
}

// Once the user has given you permission to share his data
OneSignal.provideUserConsent( true );
```

The consent setting is persisted between sessions. This means that your application only ever needs to call provideConsent a single time and the setting will be persisted (remembered) by the SDK.

If `OneSignal.settings.autoRegister` is set to `false` when initializing the extension, you will need to call `OneSignal.register()` later at some point to attempt registration with the notification servers. Generally, it is recommended to avoid auto registration to provide better user experience for users who launch your app for the very first time.

#### Managing user subscription

You can opt users out of receiving all notifications through OneSignal using:

```as3
OneSignal.setSubscription( false );
```

You can pass `true` later to opt users back into notifications.

#### Tagging

By using tags you can segment your user base and create personalized notifications. Use one of the following methods to assign new or update an existing tag:

```as3
// key - value
OneSignal.sendTag( "profession", "warrior", function():void {
    trace("Send tag completed");
} );

// Or multiple tags at a time
OneSignal.sendTags( {
    "profession": "warrior",
    "area": "desert"
}, function():void {
    trace("Send tags completed");
} );
```

Use one of the following methods to delete previously set tags:

```as3
OneSignal.deleteTag( "profession", function():void {
    trace("Delete tag completed");
} );

// Or multiple tags at a time
OneSignal.deleteTags( new <String>["profession", "area"], function():void {
    trace("Delete tags completed");
} );
```

Use the following method to retrieve the values current user has been tagged with:

```as3
OneSignal.getTags( onTagsRetrieved );
...
private function onTagsRetrieved( tags:Object ):void {
    // tags may be null if there's a connection error or user has not been tagged
    if( tags != null ) {
        trace( tags["profession"] ); // warrior
        trace( tags["area"] ); // desert
    }
}
```

## Documentation
Generated ActionScript documentation is available in the [docs](docs/) directory, or can be generated by running `ant asdoc` from the [build](build/) directory.

## Build ANE
ANT build scripts are available in the [build](build/) directory. Edit [build.properties](build/build.properties) to correspond with your local setup.

## Author
The ANE has been written by [Marcel Piestansky](https://twitter.com/marpies) and is distributed under [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## Changelog

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
