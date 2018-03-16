//
//  NSObject+OpenLocationCode_m.h
//  OpenLocationCode
//
//  Created by Edwin Groothuis on 15/3/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

// Ported from open-location-code-swift.
// Original license:

//
//  Copyright 2017 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//===----------------------------------------------------------------------===//
//
//  Convert between decimal degree coordinates and Open Location Codes. Shorten
//  and recover Open Location Codes for a given reference location.
//
//  Authored by William Denniss. Ported from openlocationcode.py.
//
//===----------------------------------------------------------------------===//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "OLCArea.h"

@interface OLCConvertor : NSObject

- (NSString *)encodeLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
- (NSString *)encodeLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon codeLength:(NSInteger)codeLength;
- (OLCArea *)decode:(NSString *)code;
- (NSString *)shortenCode:(NSString *)code latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
- (NSString *)recoverNearestWithShortcode:(NSString *)code referenceLatitude:(CLLocationDegrees)lat referenceLongitude:(CLLocationDegrees)lon;

@end
