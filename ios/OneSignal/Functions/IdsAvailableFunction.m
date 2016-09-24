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

#import "IdsAvailableFunction.h"
#import "AIROneSignal.h"
#import "OneSignalUIAppDelegate.h"

FREObject pushos_idsAvailable( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    /* [OneSignal IdsAvailable] must be called after [OneSignal init].
     * The callback is registered in AS3 so it will be called after
     * the SDK is initialized, no point calling [OneSignal IdsAvailable] here */
    if( [[AIROneSignal sharedInstance] appDelegate] == nil ) return nil; // SDK not initialized yet
    
    [AIROneSignal log:@"OneSignal::idsAvailable"];
    [[[AIROneSignal sharedInstance] appDelegate] idsAvailable];
    
    return nil;
}