//
//  main.m
//  OpenLocationCode
//
//  Created by Edwin Groothuis on 15/3/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OLCConvertor.h"

int main(int argc, const char *argv[])
{

    OLCConvertor *olc = [[OLCConvertor alloc] init];

    // Encode a location with default code length.
    NSString *code = [olc encodeLatitude:37.421908
                               longitude:-122.084681];
    NSLog(@"Open Location Code: %@ (expected: 849VCWC8+Q48)", code);

    // Encode a location with specific code length.
    NSString *code10Digit = [olc encodeLatitude:37.421908
                                      longitude:-122.084681
                                     codeLength:10];
    NSLog(@"Open Location Code: %@ (expected: 849VCWC8+Q4)", code10Digit);

    // Decode a full code:
    OLCArea *coord = [olc decode:@"849VCWC8+Q48"];
    NSLog(@"Center is %.9f, %.9f (expected: 37.4219125, -122.084671875)", coord.latitudeCenter, coord.longitudeCenter);

    // Attempt to trim the first characters from a code:
    NSString *shortCode = [olc shortenCode:@"849VCWC8+Q48"
                                  latitude:37.4
                                 longitude:-122.0];
    NSLog(@"Short Code: %@ (expected CWC8+Q48)", shortCode);

    // Recover the full code from a short code:
    NSString *recoveredCode = [olc recoverNearestWithShortcode:@"CWC8+Q48"
                                             referenceLatitude:37.4
                                            referenceLongitude:-122.0];
    NSLog(@"Recovered Full Code: %@ (expected 849VCWC8+Q48)", recoveredCode);

    return 0;
}
