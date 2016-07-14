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
        mHasRegistered = autoRegister;
        mOneSignal = [[OneSignal alloc] initWithLaunchOptions:[MPUIApplicationDelegate launchOptions] appId:oneSignalAppId handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
            //
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

@end
