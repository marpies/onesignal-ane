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

#import "PostNotificationFunction.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import <AIRExtHelpers/MPStringUtils.h>
#import "AIROneSignal.h"
#import "OneSignalEvent.h"

FREObject pushos_postNotification( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    [AIROneSignal log:@"pushos_postNotification"];
    NSString* parametersString = [MPFREObjectUtils getNSString:argv[0]];
    int callbackID = [MPFREObjectUtils getInt:argv[1]];
    
    NSError* jsonError = [[NSError alloc] init];
    NSData* jsonData = [parametersString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    /* String parsed to JSON successfully */
    if( jsonResult != nil ) {
        [[[AIROneSignal sharedInstance] appDelegate] postNotification:jsonResult callbackID:callbackID];
    }
    /* There was an error parsing the JSON String */
    else {
        NSMutableDictionary* errorResponse = [NSMutableDictionary dictionary];
        errorResponse[@"callbackID"] = [NSNumber numberWithInt:callbackID];
        errorResponse[@"errorResponse"] = @{ @"error": jsonError.localizedDescription };
        [AIROneSignal dispatchEvent:POST_NOTIFICATION_ERROR withMessage:[MPStringUtils getJSONString:errorResponse]];
    }
    return nil;
}