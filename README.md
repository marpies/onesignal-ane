# OneSignal | Native extension for Adobe AIR (iOS &amp; Android)

[OneSignal](https://onesignal.com/) is a free service that allows high volume, cross platform push notification delivery. This extension provides cross-platform API for Adobe AIR apps targeting iOS and Android.

Development of this extension is supported by [Family Train Inc.](https://github.com/mastertigra)

## Features

* Receiving push notifications sent from [OneSignal dashboard](https://onesignal.com/)
* Managing user subscription
* Segmenting users using tags
* Posting notifications from device

## Native SDK versions

* iOS `v2.15.4` (Oct 20, 2020)
* Android `v3.15.4` (Oct 20, 2020)

## Requirements

* iOS 10+
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

On iOS, you may need to add the following ANE to correctly register with Apple push servers:

* [com.distriqt.Core](https://github.com/distriqt/ANE-Core)

At the beginning of your code, call the `init` method of the `Core` extension:

```as3
import com.distriqt.extension.core.Core;

...

Core.init();
```

If you are targeting Android, add the following dependency extensions:

* [com.google.firebase.firebase-analytics-ktx](https://github.com/tuarua/Android-ANE-Dependencies/tree/master/anes/firebase)
* [com.google.firebase.firebase-components](https://github.com/tuarua/Android-ANE-Dependencies/tree/master/anes/firebase)
* [com.google.firebase.firebase-iid](https://github.com/tuarua/Android-ANE-Dependencies/tree/master/anes/firebase)
* [com.google.firebase.firebase-messaging](https://github.com/tuarua/Android-ANE-Dependencies/tree/master/anes/firebase)
* [com.tuarua.frekotlin](https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin)
* [androidx.core](https://github.com/distriqt/ANE-AndroidSupport)
* [com.distriqt.playservices.Base](https://github.com/distriqt/ANE-GooglePlayServices)
* [com.distriqt.playservices.AdsIdentifier](https://github.com/distriqt/ANE-GooglePlayServices)

> Credits to [Distriqt](https://github.com/distriqt) and [tuarua](https://github.com/tuarua) for providing these extensions.

Your app descriptor should now contain the following:

```xml
<extensions>
    <extensionID>com.marpies.ane.onesignal</extensionID>
    
    <extensionID>com.google.firebase.firebase-analytics-ktx</extensionID>
    <extensionID>com.google.firebase.firebase-components</extensionID>
    <extensionID>com.google.firebase.firebase-iid</extensionID>
    <extensionID>com.google.firebase.firebase-messaging</extensionID>
    <extensionID>com.tuarua.frekotlin</extensionID>

    <extensionID>androidx.core</extensionID>
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>
    <extensionID>com.distriqt.playservices.AdsIdentifier</extensionID>
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
        <string>10.0</string>
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
            <uses-sdk android:minSdkVersion="21" android:targetSdkVersion="28" />

            <uses-permission android:name="android.permission.INTERNET" />
            <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
            <uses-permission android:name="android.permission.WAKE_LOCK" />

            <!-- Required by older versions of Google Play services to create IID tokens -->
            <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
            <uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />

            <!-- Create a unique permission for your app and use it so only your app can receive your OneSignal messages. -->
            <permission android:name="{APP-PACKAGE-NAME}.permission.C2D_MESSAGE" android:protectionLevel="signature" />
            <uses-permission android:name="{APP-PACKAGE-NAME}.permission.C2D_MESSAGE" />

            <!--
            Required so the device vibrates on receiving a push notification.
                    Vibration settings of the device still apply.
                -->
            <uses-permission android:name="android.permission.VIBRATE" />

            <!--
            Use to restore notifications the user hasn't interacted with.
                    They could be missed notifications if the user reboots their device if this isn't in place.
                -->
            <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
            
            <!-- Samsung -->
            <uses-permission android:name="com.sec.android.provider.badge.permission.READ" />
            <uses-permission android:name="com.sec.android.provider.badge.permission.WRITE" />
            <!-- HTC -->
            <uses-permission android:name="com.htc.launcher.permission.READ_SETTINGS" />
            <uses-permission android:name="com.htc.launcher.permission.UPDATE_SHORTCUT" />
            <!-- Sony -->
            <uses-permission android:name="com.sonyericsson.home.permission.BROADCAST_BADGE" />
            <uses-permission android:name="com.sonymobile.home.permission.PROVIDER_INSERT_BADGE" />
            <!-- Apex -->
            <uses-permission android:name="com.anddoes.launcher.permission.UPDATE_COUNT" />
            <!-- Solid -->
            <uses-permission android:name="com.majeur.launcher.permission.UPDATE_BADGE" />
            <!-- Huawei -->
            <uses-permission android:name="com.huawei.android.launcher.permission.CHANGE_BADGE" />
            <uses-permission android:name="com.huawei.android.launcher.permission.READ_SETTINGS" />
            <uses-permission android:name="com.huawei.android.launcher.permission.WRITE_SETTINGS" />
            <!-- ZUK -->
            <uses-permission android:name="android.permission.READ_APP_BADGE" />
            <!-- OPPO -->
            <uses-permission android:name="com.oppo.launcher.permission.READ_SETTINGS" />
            <uses-permission android:name="com.oppo.launcher.permission.WRITE_SETTINGS" />
            <!-- EvMe -->
            <uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_READ" />
            <uses-permission android:name="me.everything.badger.permission.BADGE_COUNT_WRITE" />

            <application android:appComponentFactory="androidx.core.app.CoreComponentFactory" android:enabled="true">
                <meta-data android:name="android.max_aspect" android:value="2.1" />
                <activity android:excludeFromRecents="false" android:hardwareAccelerated="true">
                    <intent-filter>
                        <action android:name="android.intent.action.MAIN" />
                        <category android:name="android.intent.category.LAUNCHER" />
                    </intent-filter>
                </activity>
                <service android:name="com.google.firebase.components.ComponentDiscoveryService" android:directBootAware="true"
                    android:exported="false">
                    <meta-data android:name="com.google.firebase.components:com.google.firebase.iid.Registrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.analytics.connector.internal.AnalyticsConnectorRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.analytics.ktx.FirebaseAnalyticsKtxRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data android:name="com.google.firebase.components:com.google.firebase.ktx.FirebaseCommonKtxRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.datatransport.TransportRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.installations.FirebaseInstallationsRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                    <meta-data
                        android:name="com.google.firebase.components:com.google.firebase.messaging.FirebaseMessagingRegistrar"
                        android:value="com.google.firebase.components.ComponentRegistrar" />
                </service>
                <receiver android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver" android:exported="true"
                    android:permission="com.google.android.c2dm.permission.SEND">
                    <intent-filter>
                        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                        <category android:name="{APP-PACKAGE-NAME}" />
                    </intent-filter>
                </receiver>
                <receiver android:name="com.google.android.gms.measurement.AppMeasurementReceiver" android:enabled="true"
                    android:exported="false"></receiver>
                <service android:name="com.google.android.gms.measurement.AppMeasurementService" android:enabled="true"
                    android:exported="false" />
                <service android:name="com.google.android.gms.measurement.AppMeasurementJobService" android:enabled="true"
                    android:exported="false" android:permission="android.permission.BIND_JOB_SERVICE" />
                <activity android:name="com.google.android.gms.common.api.GoogleApiActivity" android:exported="false"
                    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
                <meta-data android:name="com.google.android.gms.version"
                    android:value="@integer/google_play_services_version" />
                <provider android:name="com.google.firebase.provider.FirebaseInitProvider"
                    android:authorities="{APP-PACKAGE-NAME}.firebaseinitprovider" android:directBootAware="true"
                    android:exported="false" android:initOrder="100" />
                <service android:name="com.google.android.datatransport.runtime.backends.TransportBackendDiscovery"
                    android:exported="false">
                    <meta-data android:name="backend:com.google.android.datatransport.cct.CctBackendFactory"
                        android:value="cct" />
                </service>
                <service
                    android:name="com.google.android.datatransport.runtime.scheduling.jobscheduling.JobInfoSchedulerService"
                    android:exported="false" android:permission="android.permission.BIND_JOB_SERVICE"></service>
                <receiver
                    android:name="com.google.android.datatransport.runtime.scheduling.jobscheduling.AlarmManagerSchedulerBroadcastReceiver"
                    android:exported="false" />
                <!--
                        FirebaseMessagingService performs security checks at runtime,
                        but set to not exported to explicitly avoid allowing another app to call it.
                    -->
                <service android:name="com.google.firebase.messaging.FirebaseMessagingService" android:directBootAware="true"
                    android:exported="false">
                    <intent-filter android:priority="-500">
                        <action android:name="com.google.firebase.MESSAGING_EVENT" />
                    </intent-filter>
                </service>

                <meta-data android:name="onesignal_app_id" android:value="{ONE-SIGNAL-APP-ID}" />

                <receiver android:name="com.onesignal.GcmBroadcastReceiver"
                    android:permission="com.google.android.c2dm.permission.SEND">
                    <!-- High priority so OneSignal payloads can be filtered from other GCM receivers if filterOtherGCMReceivers is enabled. -->
                    <intent-filter android:priority="999">
                        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                        <category android:name="{APP-PACKAGE-NAME}" />
                    </intent-filter>
                </receiver>
                <receiver android:name="com.onesignal.NotificationOpenedReceiver" />
                <service android:name="com.onesignal.GcmIntentService" />
                <service android:name="com.onesignal.GcmIntentJobService"
                    android:permission="android.permission.BIND_JOB_SERVICE" />
                <service android:name="com.onesignal.RestoreJobService"
                    android:permission="android.permission.BIND_JOB_SERVICE" />
                <service android:name="com.onesignal.RestoreKickoffJobService"
                    android:permission="android.permission.BIND_JOB_SERVICE" />
                <service android:name="com.onesignal.SyncService" android:stopWithTask="true" />
                <service android:name="com.onesignal.SyncJobService" android:permission="android.permission.BIND_JOB_SERVICE" />
                <activity android:name="com.onesignal.PermissionsActivity"
                    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
                <service android:name="com.onesignal.NotificationRestoreService" />
                <receiver android:name="com.onesignal.BootUpReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.BOOT_COMPLETED" />
                        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                    </intent-filter>
                </receiver>
                <receiver android:name="com.onesignal.UpgradeReceiver">
                    <intent-filter>
                        <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
                    </intent-filter>
                </receiver>
            </application>
        </manifest>
        ]]>
    </manifestAdditions>
</android>
```

In the snippet above, replace:
* `{APP-PACKAGE-NAME}` with your app package name (value of `id` element in your AIR app descriptor). Remember it's prefixed with `air.` when packaged by AIR SDK, unless you knowingly prevent this.
* `{ONE-SIGNAL-APP-ID}` with your OneSignal app id

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

## [Changelog](CHANGELOG.md)