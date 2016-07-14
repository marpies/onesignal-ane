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

@implementation OneSignalUIAppDelegate {
    BOOL mHasRegistered;
    OneSignal* mOneSignal;
}

- (id) initWithOneSignalAppId:(NSString*) oneSignalAppId autoRegister:(BOOL) autoRegister {
    self = [super init];
    if( self ) {
        if( !autoRegister ) {
            [AIROneSignal log:@"Auto register is disabled"];
        }
        /* Manually dispatch notification from launchOptions, if there's one */
        NSDictionary* launchOptions = [MPUIApplicationDelegate launchOptions];
        [self parseLaunchOptions:launchOptions];
        /* Initialize OneSignal */
        mHasRegistered = autoRegister;
        mOneSignal = [[OneSignal alloc] initWithLaunchOptions:[MPUIApplicationDelegate launchOptions] appId:oneSignalAppId handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
            [AIROneSignal log:@"OneSignalUIAppDelegate::handleNotification"];
            [self dispatchNotificationMessage:message additionalData:additionalData isActive:isActive];
        } autoRegister:autoRegister];
        
        if( autoRegister ) {
            [self addTokenCallback];
        }
    }
    return self;
}

- (void) registerForPushNotifications {
    if( !mHasRegistered ) {
        mHasRegistered = YES;
        [mOneSignal registerForPushNotifications];
        [self addTokenCallback];
    } else {
        [AIROneSignal log:@"User has already registered for push notifications, ignoring."];
    }
}

- (void) setSubscription:(BOOL) subscription {
    [mOneSignal setSubscription:subscription];
}

- (void) addTokenCallback {
    [mOneSignal IdsAvailable:^(NSString *userId, NSString *pushToken) {
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

- (void) dispatchNotificationMessage:(NSString*) message additionalData:(NSDictionary*) additionalData isActive:(BOOL) isActive {
    [AIROneSignal log:@"OneSignalUIAppDelegate::dispatchNotificationMessage"];
    NSMutableDictionary* response = additionalData ? [NSMutableDictionary dictionaryWithDictionary:additionalData] : [NSMutableDictionary dictionary];
    response[@"message"] = message;
    response[@"isActive"] = [NSNumber numberWithBool:isActive];
    [AIROneSignal dispatchEvent:OS_NOTIFICATION_RECEIVED withMessage:[MPStringUtils getJSONString:response]];
}

- (void) parseLaunchOptions:(NSDictionary*) launchOptions {
    if( !launchOptions ) return;
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if( !userInfo ) return;
    
    /* Message, title */
    NSString* message = nil;
    NSString* title = nil;
    NSMutableDictionary* additionalData = nil;
    NSDictionary* aps = [userInfo objectForKey:@"aps"];
    id alert = aps[@"alert"];
    if( alert ) {
        if( [alert isKindOfClass:[NSString class]] ) {
            message = alert;
        } else if( [alert isKindOfClass:[NSDictionary class]] ) {
            message = alert[@"body"];
            title = alert[@"title"];
        }
    } else if( userInfo[@"m"] ) {
        message = userInfo[@"m"][@"body"];
        title = userInfo[@"m"][@"title"];
    }
    if( title ) {
        additionalData = [NSMutableDictionary dictionary];
        additionalData[@"title"] = title;
    }
    /* Additional data */
    id custom = userInfo[@"custom"];
    if( custom ) {
        if( !additionalData ) {
            additionalData = [NSMutableDictionary dictionaryWithDictionary:custom[@"a"]];
        } else {
            [additionalData addEntriesFromDictionary:custom[@"a"]];
        }
    }
    /* Buttons */
    NSMutableArray* buttons = nil;
    id buttonsRaw = userInfo[@"o"];
    if( buttonsRaw ) {
        buttons = [NSMutableArray array];
        for( NSDictionary* button in buttonsRaw ) {
            [buttons addObject:@{
                                 @"id": button[@"i"] ? button[@"i"] : button[@"n"],
                                 @"text": button[@"n"]
                                }];
        }
        if( !additionalData ) {
            additionalData = [NSMutableDictionary dictionary];
        }
        additionalData[@"actionButtons"] = buttons;
        additionalData[@"actionSelected"] = @"__DEFAULT__";
    }
    
    [AIROneSignal log:[NSString stringWithFormat:@"launchNotification: m: %@, t: %@, a: %@", message, title, additionalData]];
    [self dispatchNotificationMessage:message additionalData:additionalData isActive:NO];
}

@end
