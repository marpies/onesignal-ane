/**
 * Copyright 2015-2016 Marcel Piestansky (http://marpies.com)
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
#import <UIKit/UIKit.h>

@protocol MPUIApplicationListener <NSObject>

@optional

- (BOOL)application:(nullable UIApplication *)application openURL:(nullable NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nullable id)annotation;

- (void)applicationDidBecomeActive:(nullable UIApplication *)application;
- (void)applicationDidEnterBackground:(nullable UIApplication *)application;

- (void)application:(nullable UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nullable NSData *)deviceToken;
- (void)application:(nullable UIApplication *)application didRegisterUserNotificationSettings:(nullable UIUserNotificationSettings *)notificationSettings;
- (void)application:(nullable UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nullable NSError *)error;
- (void)application:(nullable UIApplication *)application didReceiveRemoteNotification:(nullable NSDictionary *)userInfo;
- (void)application:(nullable UIApplication *)application didReceiveRemoteNotification:(nullable NSDictionary *)userInfo fetchCompletionHandler:(nullable void (^)(UIBackgroundFetchResult result))completionHandler;
- (void)application:(nullable UIApplication *)application handleActionWithIdentifier:(nullable nullable NSString *)identifier forRemoteNotification:(nullable NSDictionary *)userInfo completionHandler:(nullable void(^)())completionHandler;


@end
