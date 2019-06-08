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

#import <Foundation/Foundation.h>

@interface OneSignalUIAppDelegate : NSObject

- (void) startWithOneSignalAppId:(nonnull NSString*) oneSignalAppId autoRegister:(BOOL) autoRegister enableInAppAlerts:(BOOL) enableInAppAlerts;
- (void) registerForPushNotifications;
- (void) setSubscription:(BOOL) subscription;
- (BOOL) getSubscription;
- (void) sendTags:(nullable NSDictionary*) tags callbackID:(int) callbackID;
- (void) deleteTags:(nullable NSArray*) tags callbackID:(int) callbackID;
- (void) getTags:(int) callbackID;
- (void) postNotification:(nullable NSDictionary*) parameters callbackID:(int) callbackID;
- (void) idsAvailable;
- (BOOL) isInitialized;

@end
