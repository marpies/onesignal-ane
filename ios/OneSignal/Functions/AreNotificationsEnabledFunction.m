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

#import "AreNotificationsEnabledFunction.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import <UIKit/UIKit.h>
#import "AIROneSignal.h"

FREObject pushos_notificationsEnabled( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    [AIROneSignal log:@"pushos_notificationsEnabled"];
    /* iOS 8+ */
    if( [[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)] ) {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        BOOL subscription = [[[AIROneSignal sharedInstance] appDelegate] getSubscription];
        BOOL atLeastBanners = types & UIRemoteNotificationTypeAlert; // Ignore sound or app badge settings
        BOOL result = subscription && atLeastBanners && [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        return [MPFREObjectUtils getFREObjectFromBOOL:result];
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return [MPFREObjectUtils getFREObjectFromBOOL:types != UIRemoteNotificationTypeNone];
    }
    return nil;
}