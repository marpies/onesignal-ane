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
#import "InitFunction.h"
#import "OneSignalUIAppDelegate.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import <OneSignal/OneSignal.h>

FREObject pushos_init( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    /* Already initialized */
    if( [[[AIROneSignal sharedInstance] appDelegate] isInitialized]) return nil;
    
    NSString* oneSignalAppId = [MPFREObjectUtils getNSString:argv[0]];
    BOOL autoRegister = [MPFREObjectUtils getBOOL:argv[1]];
    BOOL enableInAppAlerts = [MPFREObjectUtils getBOOL:argv[2]];
    BOOL showLogs = [MPFREObjectUtils getBOOL:argv[3]];
    
    [AIROneSignal showLogs:showLogs];
    if( showLogs ) {
        [OneSignal setLogLevel:ONE_S_LL_DEBUG visualLevel:ONE_S_LL_NONE];
    }
    
    [AIROneSignal log:@"pushos_init"];
    /* Start the delegate */
    [[[AIROneSignal sharedInstance] appDelegate] startWithOneSignalAppId:oneSignalAppId autoRegister:autoRegister enableInAppAlerts:enableInAppAlerts];

    return nil;
}
