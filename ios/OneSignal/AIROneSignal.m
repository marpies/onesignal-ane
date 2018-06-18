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

#import "AIROneSignal.h"
#import "Functions/InitFunction.h"
#import "Functions/RegisterFunction.h"
#import "Functions/GetSDKVersionFunction.h"
#import "Functions/SetSubscriptionFunction.h"
#import "Functions/SendTagsFunction.h"
#import "Functions/DeleteTagsFunction.h"
#import "Functions/GetTagsFunction.h"
#import "Functions/AreNotificationsEnabledFunction.h"
#import "Functions/AreNotificationsAvailableFunction.h"
#import "Functions/PostNotificationFunction.h"
#import "Functions/IdsAvailableFunction.h"
#import "Functions/ClearNotificationsFunction.h"
#import "Functions/ProvideUserConsentFunction.h"
#import "Functions/SetRequiresUserPrivacyConsentFunction.h"
#import "Functions/GetUserProvidedPrivacyConsentFunction.h"

static BOOL AIROneSignalLogEnabled = NO;
FREContext AIROneSignalExtContext = nil;
static AIROneSignal* AIROneSignalSharedInstance = nil;

@implementation AIROneSignal

@synthesize appDelegate;

+ (id) sharedInstance {
    if( AIROneSignalSharedInstance == nil ) {
        AIROneSignalSharedInstance = [[AIROneSignal alloc] init];
        [AIROneSignalSharedInstance setAppDelegate:[[OneSignalUIAppDelegate alloc] init]];
    }
    return AIROneSignalSharedInstance;
}

+ (void) dispatchEvent:(const NSString*) eventName {
    [self dispatchEvent:eventName withMessage:@""];
}

+ (void) dispatchEvent:(const NSString*) eventName withMessage:(NSString*) message {
    NSString* messageText = message ? message : @"";
    FREDispatchStatusEventAsync( AIROneSignalExtContext, (const uint8_t*) [eventName UTF8String], (const uint8_t*) [messageText UTF8String] );
}

+ (void) log:(const NSString*) message {
    if( AIROneSignalLogEnabled ) {
        NSLog( @"[iOS-OneSignal] %@", message );
    }
}

+ (void) showLogs:(BOOL) showLogs {
    AIROneSignalLogEnabled = showLogs;
}

@end

/**
 *
 *
 * Context initialization
 *
 *
 **/

FRENamedFunction AIROneSignal_extFunctions[] = {
    { (const uint8_t*) "init",                          0, pushos_init },
    { (const uint8_t*) "register",                      0, pushos_register },
    { (const uint8_t*) "sdkVersion",                    0, pushos_sdkVersion },
    { (const uint8_t*) "setSubscription",               0, pushos_setSubscription },
    { (const uint8_t*) "sendTags",                      0, pushos_sendTags },
    { (const uint8_t*) "deleteTags",                    0, pushos_deleteTags },
    { (const uint8_t*) "getTags",                       0, pushos_getTags },
    { (const uint8_t*) "areNotificationsEnabled",       0, pushos_notificationsEnabled },
    { (const uint8_t*) "areNotificationsAvailable",     0, pushos_notificationsAvailable },
    { (const uint8_t*) "postNotification",              0, pushos_postNotification },
    { (const uint8_t*) "idsAvailable",                  0, pushos_idsAvailable },
    { (const uint8_t*) "clearNotifications",            0, pushos_clearNotifications },
    { (const uint8_t*) "setRequiresUserPrivacyConsent", 0, pushos_setRequiresUserPrivacyConsent },
    { (const uint8_t*) "provideUserConsent",            0, pushos_provideUserConsent },
    { (const uint8_t*) "userProvidedPrivacyConsent",    0, pushos_userProvidedPrivacyConsent }
};

void OneSignalContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet ) {
    *numFunctionsToSet = sizeof( AIROneSignal_extFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = AIROneSignal_extFunctions;
    
    AIROneSignalExtContext = ctx;
}

void OneSignalContextFinalizer( FREContext ctx ) { }

void OneSignalInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &OneSignalContextInitializer;
    *ctxFinalizerToSet = &OneSignalContextFinalizer;
}

void OneSignalFinalizer( void* extData ) { }







