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

#ifndef AIR_MPFREObjectUtils_h
#define AIR_MPFREObjectUtils_h

#import "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>

@interface MPFREObjectUtils : NSObject

/**
* From FREObject to Objective C
*/

+ (NSString*) getNSString:(FREObject) object;
+ (NSArray*) getNSArray:(FREObject) object;
+ (BOOL) getBOOL:(FREObject) object;
+ (int) getInt:(FREObject) object;
+ (NSDictionary*) getNSDictionary:(FREObject) object;
+ (double) getDouble:(FREObject) object;
+ (NSArray*) getMediaSourcesArray:(FREObject) object;

/**
* From Objective C to FREObject
*/

+ (FREObject) getFREObjectFromBOOL:(BOOL) value;
+ (FREObject) getFREObjectFromNSString:(NSString*) value;
+ (FREObject) getFREObjectFromNSSet:(NSSet*) set;
+ (FREObject) getFREObjectFromDouble:(double) value;

@end

#endif