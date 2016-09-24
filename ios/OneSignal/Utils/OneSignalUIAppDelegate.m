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

#import "OneSignalUIAppDelegate.h"
#import "AIROneSignal.h"
#import <OneSignal/OneSignal.h>
#import <AIRExtHelpers/MPUIApplicationDelegate.h>
#import <AIRExtHelpers/MPStringUtils.h>
#import "OneSignalEvent.h"

static NSString* const kPushOSDefaultsSubscriptionKey = @"pushos_subscription";

@implementation OneSignalUIAppDelegate {
    BOOL mHasRegistered;
}

#pragma mark - Public

- (id) initWithOneSignalAppId:(NSString*) oneSignalAppId autoRegister:(BOOL) autoRegister enableInAppAlerts:(BOOL) enableInAppAlerts {
    self = [super init];
    if( self ) {
        if( !autoRegister ) {
            [AIROneSignal log:@"Auto register is disabled"];
        }
        /* Initialize OneSignal */
        mHasRegistered = autoRegister;
        
        OSNotificationDisplayType inFocusDisplayType = enableInAppAlerts ? OSNotificationDisplayTypeInAppAlert : OSNotificationDisplayTypeNone;
        [OneSignal initWithLaunchOptions:[MPUIApplicationDelegate launchOptions] appId:oneSignalAppId handleNotificationReceived:^(OSNotification *notification) {
            [AIROneSignal log:@"OneSignalUIAppDelegate::handleNotificationReceived"];
            /* Notification in this handler will only be dispatched to AIR if the app is in focus,
             * otherwise we'll wait for user interaction and the notification will be handled in 'handleNotificationAction' */
            if( notification.displayType == OSNotificationDisplayTypeNone ) {
                [AIROneSignal log:@"Received notification while app is active, dispatching."];
                [self dispatchNotification:[self getJSONForNotification:notification]];
            } else {
                [AIROneSignal log:@"Received notification while in background, waiting for user interaction."];
            }
        } handleNotificationAction:^(OSNotificationOpenedResult *result) {
            [AIROneSignal log:@"OneSignalUIAppDelegate::handleNotificationAction"];
            [self dispatchNotification:[self getJSONForNotification:result.notification notificationAction:result.action]];
        } settings:@{
                     kOSSettingsKeyInAppAlerts: @(enableInAppAlerts),
                     kOSSettingsKeyAutoPrompt: @(autoRegister),
                     kOSSettingsKeyInFocusDisplayOption: @(inFocusDisplayType)
                    }];
        
        if( autoRegister ) {
            [self idsAvailable];
        }
    }
    return self;
}

- (void) registerForPushNotifications {
    if( !mHasRegistered ) {
        mHasRegistered = YES;
        [OneSignal registerForPushNotifications];
        [self idsAvailable];
    } else {
        [AIROneSignal log:@"User has already registered for push notifications, ignoring."];
    }
}

- (void) setSubscription:(BOOL) subscription {
    [OneSignal setSubscription:subscription];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:subscription forKey:kPushOSDefaultsSubscriptionKey];
}

- (BOOL) getSubscription {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id isKeySet = [defaults objectForKey:kPushOSDefaultsSubscriptionKey];
    if( isKeySet != nil ) {
        /* Key was set earlier, get the actual value */
        return [defaults boolForKey:kPushOSDefaultsSubscriptionKey];
    }
    /* Key was not set earlier, default to YES */
    return YES;
}

- (void) sendTags:(NSDictionary*) tags {
    [OneSignal sendTags: tags];
}

- (void) deleteTags:(NSArray*) tags {
    [OneSignal deleteTags: tags];
}

- (void) getTags:(int) callbackID {
    [OneSignal getTags:^(NSDictionary *result) {
        [AIROneSignal log:@"OneSignal::getTags success"];
        [self dispatchTags:result forCallback:callbackID];
    } onFailure:^(NSError *error) {
        [AIROneSignal log:[NSString stringWithFormat:@"OneSignal::getTags error: %@", error.localizedDescription]];
        [self dispatchTags:nil forCallback:callbackID];
    }];
}

- (void) postNotification:(NSDictionary*) parameters callbackID:(int) callbackID {
    [OneSignal postNotification:parameters onSuccess:^(NSDictionary *result) {
        [AIROneSignal log:@"OneSignalUIAppDelegate::postNotification | success"];
        NSMutableDictionary* response = [NSMutableDictionary dictionary];
        response[@"callbackID"] = [NSNumber numberWithInt:callbackID];
        response[@"successResponse"] = result;
        [AIROneSignal dispatchEvent:POST_NOTIFICATION_SUCCESS withMessage:[MPStringUtils getJSONString:response]];
    } onFailure:^(NSError *error) {
        [AIROneSignal log:@"OneSignalUIAppDelegate::postNotification | error"];
        NSMutableDictionary* response = [NSMutableDictionary dictionary];
        response[@"callbackID"] = [NSNumber numberWithInt:callbackID];
        response[@"errorResponse"] = @{ @"error": error.localizedDescription };
        [AIROneSignal dispatchEvent:POST_NOTIFICATION_ERROR withMessage:[MPStringUtils getJSONString:response]];
    }];
}

- (void) idsAvailable {
    [OneSignal IdsAvailable:^(NSString *userId, NSString *pushToken) {
        [AIROneSignal log:[NSString stringWithFormat:@"OneSignal::idsAvailable %@ | token: %@", userId, pushToken]];
        NSMutableDictionary* response = [NSMutableDictionary dictionary];
        if( userId != nil ) {
            response[@"userId"] = userId;
        }
        if( pushToken != nil ) {
            response[@"pushToken"] = pushToken;
        }
        [AIROneSignal dispatchEvent:OS_TOKEN_RECEIVED withMessage:[MPStringUtils getJSONString:response]];
    }];
}


#pragma mark - Private

- (NSDictionary*) getJSONForNotification:(nonnull OSNotification*) notification {
    return [self getJSONForNotification:notification notificationAction:nil];
}

- (NSDictionary*) getJSONForNotification:(nonnull OSNotification*) notification notificationAction:(nullable OSNotificationAction*) action {
    OSNotificationPayload* payload = notification.payload;
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    json[@"message"] = payload.body;
    json[@"isActive"] = @(notification.displayType == OSNotificationDisplayTypeNone);
    if( payload.title != nil ) {
        json[@"title"] = payload.title;
    }
    if( payload.subtitle != nil ) {
        json[@"subtitle"] = payload.subtitle;
    }
    if( payload.launchURL != nil ) {
        json[@"launchURL"] = payload.launchURL;
    }
    if( payload.additionalData != nil ) {
        NSArray* keys = [[payload additionalData] allKeys];
        for( id key in keys ) {
            json[key] = payload.additionalData[key];
        }
    }
    if( payload.actionButtons != nil ) {
        json[@"actionButtons"] = [self getButtons:(NSArray*)payload.actionButtons];
        NSString* actionSelected = @"__DEFAULT__";
        if( action != nil && action.actionID != nil ) {
            actionSelected = action.actionID;
        }
        json[@"actionSelected"] = actionSelected;
    }
    return json;
}

- (void) dispatchNotification:(NSDictionary*) notificationJSON {
    [AIROneSignal dispatchEvent:OS_NOTIFICATION_RECEIVED withMessage:[MPStringUtils getJSONString:notificationJSON]];
}

- (void) dispatchTags:(nullable NSDictionary*) tags forCallback:(int) callbackID {
    NSMutableDictionary* response = [NSMutableDictionary dictionary];
    response[@"callbackID"] = [NSNumber numberWithInt:callbackID];
    if( tags != nil ) {
        response[@"tags"] = tags;
    }
    [AIROneSignal dispatchEvent:OS_TAGS_RECEIVED withMessage:[MPStringUtils getJSONString:response]];
}

- (NSArray*) getButtons:(NSArray*) buttonsRaw {
    NSMutableArray* buttons = [NSMutableArray array];
    for( NSDictionary* button in buttonsRaw ) {
        [buttons addObject:@{
                             @"id": button[@"i"] ? button[@"i"] : button[@"n"],
                             @"text": button[@"n"]
                             }];
    }
    return buttons;
}

@end
