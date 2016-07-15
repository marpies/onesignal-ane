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

#import "DeleteTagsFunction.h"
#import "AIROneSignal.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>

FREObject pushos_deleteTags( FREContext context, void* functionData, uint32_t argc, FREObject argv[] ) {
    [AIROneSignal log:@"pushos_deleteTags"];
    NSArray* tagList = [MPFREObjectUtils getNSArray:argv[0]];
    [[[AIROneSignal sharedInstance] appDelegate] deleteTags:tagList];
    return nil;
}