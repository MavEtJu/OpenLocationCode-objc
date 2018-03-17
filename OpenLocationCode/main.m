//
//  main.m
//  OpenLocationCode
//
//  Created by Edwin Groothuis on 15/3/18.
//  Copyright © 2018 Edwin Groothuis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OLCConvertor.h"

int runValidityTest(void);
int runShortCodeTest(void);
int runEncodingTest(void);
void testheader(char *s);
void testbool(BOOL retval, char *expected);
void teststring(NSString *s1, char *s2);
void teststring_shorterokay(NSString *s1, char *s2);
void testdot(void);
void testend(void);

int main(int argc, const char *argv[])
{
    OLCConvertor *olc = [[OLCConvertor alloc] init];
    {
        NSString *coord = [olc shortenCode:@"9C3W9QCJ+2VX" latitude:51.3701125 longitude:-1.217765625];
        NSLog(@"9C3W9QCJ+2VX shorten is %@, expected +2VX", coord);
    }
//    return 0;

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

//    runValidityTest();
    runShortCodeTest();
    runEncodingTest();

    return 0;
}

int runEncodingTest(void)
{
    return 0;
}

int runShortCodeTest(void)
{
    FILE *fin;
    if ((fin = fopen("shortCodeTests.csv", "r")) == NULL)
        return 1;

    OLCConvertor *olc = [[OLCConvertor alloc] init];

    char *line = NULL;
    size_t linecap = 0;
    ssize_t linelen;
    while ((linelen = getline(&line, &linecap, fin)) > 0) {
        if (line[0] == '#')
            continue;

        if (line[strlen(line) - 1] == '\n')
            line[strlen(line) - 1] = '\0';

        // # full code,lat,lng,shortcode,test_type
        // # test_type is R for recovery only, S for shorten only, or B for both.

        char *cfullcode, *clat, *clon, *cshortcode, *ctesttype;
        if ((cfullcode = strsep(&line, ",")) == NULL)
            return 2;
        if ((clat = strsep(&line, ",")) == NULL)
            return 2;
        if ((clon = strsep(&line, ",")) == NULL)
            return 2;
        if ((cshortcode = strsep(&line, ",")) == NULL)
            return 2;
        if ((ctesttype = strsep(&line, ",")) == NULL)
            return 2;

        CLLocationDegrees lat = atof(clat);
        CLLocationDegrees lon = atof(clon);

        testheader(cfullcode);

        if (ctesttype[0] == 'B' || ctesttype[0] == 'S') {
            NSString *fullcode = [NSString stringWithCString:cfullcode encoding:NSASCIIStringEncoding];
            NSString *shortcode = [olc shortenCode:fullcode latitude:lat longitude:lon];
            teststring_shorterokay(shortcode, cshortcode);
        } else
            testdot();

        if (ctesttype[0] == 'B' || ctesttype[0] == 'R') {
            NSString *shortcode = [NSString stringWithCString:cshortcode encoding:NSASCIIStringEncoding];
            NSString *fullcode = [olc recoverNearestWithShortcode:shortcode referenceLatitude:lat referenceLongitude:lon];
            teststring(fullcode, cfullcode);
        } else
            testdot();

        testend();
    }

    fclose(fin);
    return 0;
}

int runValidityTest(void)
{
    FILE *fin;
    if ((fin = fopen("validityTests.csv", "r")) == NULL)
        return 1;

    OLCConvertor *olc = [[OLCConvertor alloc] init];

    char *line = NULL;
    size_t linecap = 0;
    ssize_t linelen;
    while ((linelen = getline(&line, &linecap, fin)) > 0) {
        if (line[0] == '#')
            continue;
        // code,isValid,isShort,isFull

        if (line[strlen(line) - 1] == '\n')
            line[strlen(line) - 1] = '\0';

        char *ccode, *isValid, *isShort, *isFull;
        BOOL retval;
        if ((ccode = strsep(&line, ",")) == NULL)
            return 2;
        if ((isValid = strsep(&line, ",")) == NULL)
            return 2;
        if ((isShort = strsep(&line, ",")) == NULL)
            return 2;
        if ((isFull = strsep(&line, ",")) == NULL)
            return 2;

        NSString *code = [NSString stringWithCString:ccode encoding:NSASCIIStringEncoding];
        testheader(ccode);
        retval = [olc isValid:code];
        testbool(retval, isValid);
        retval = [olc isShort:code];
        testbool(retval, isShort);
        retval = [olc isFull:code];
        testbool(retval, isFull);
        testend();
    }

    fclose(fin);
    return 0;
}

void testdot(void)
{
    printf("_");
}


void teststring(NSString *s1, char *expected)
{
    if ([s1 isEqualToString:[NSString stringWithCString:expected encoding:NSASCIIStringEncoding]] == YES)
        printf(".");
    else
        printf("(got '%s', expected '%s')", [s1 cStringUsingEncoding:NSASCIIStringEncoding], expected);
}

void teststring_shorterokay(NSString *s1, char *expected)
{
    NSString *e = [NSString stringWithCString:expected encoding:NSASCIIStringEncoding];
    if ([s1 isEqualToString:e] == YES)
        printf(".");
    else if ([e isEqualToString:[s1 substringFromIndex:[s1 length] - [e length]]] == YES)
        printf("<");
    else {
        printf("(got '%s', expected '%s')", [s1 cStringUsingEncoding:NSASCIIStringEncoding], expected);
    }
}

void testbool(BOOL retval, char *expected)
{
    if (retval == NO && strcmp(expected, "false") == 0)
        printf(".");
    else if (retval == YES && strcmp(expected, "true") == 0)
        printf(".");
    else if (retval == NO && strcmp(expected, "true") == 0)
        printf("(got false, expected true)");
    else if (retval == YES && strcmp(expected, "false") == 0)
        printf("(got true, expected false)");
    else
        printf("?");
}

void testheader(char *s)
{
    printf("%s:", s);
    for (unsigned long i = strlen(s); i < 20; i++)
        printf(" ");
}

void testend(void)
{
    printf("\n");
}
