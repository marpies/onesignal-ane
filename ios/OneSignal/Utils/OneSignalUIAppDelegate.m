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

@implementation OneSignalUIAppDelegate {
    OneSignal* mOneSignal;
}

- (id) initWithOneSignalAppId:(NSString*) oneSignalAppId andAutoRegister:(BOOL) autoRegister {
    self = [super init];
    if( self ) {
        if( !autoRegister ) {
            [AIROneSignal log:@"Auto register is disabled"];
        }
        mOneSignal = [[OneSignal alloc] initWithLaunchOptions:[MPUIApplicationDelegate launchOptions] appId:oneSignalAppId handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
            //
        } autoRegister:autoRegister];
    }
    return self;
}

@end
