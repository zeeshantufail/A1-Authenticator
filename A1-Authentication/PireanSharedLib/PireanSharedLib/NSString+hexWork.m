//
//  NSString+hexWork.m
//  testEncryption
//
//  Created by Simon Hagger on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+hexWork.h"

@implementation NSString (hexWork)
- (NSString *) stringFromHex 
{   
    NSMutableData *stringData = [[[NSMutableData alloc] init] autorelease];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1]; 
    }
    
    return [[[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding] autorelease];
}

/*
- (NSString *) stringToHex {
    NSData *strData = [[NSData alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding]];
    NSMutableString *mut = [NSMutableString string];
    int i;
    for (i = 0; i < [strData length]; i++)
    {
        [mut appendFormat:@"%x", ((char *)[strData bytes])[i]];
    }
    return mut;
}
*/
- (NSString *) stringToHex
{   
    NSUInteger len = [self length];
    unichar *chars = malloc(len * sizeof(unichar));
    [self getCharacters:chars];
    
    NSMutableString *hexString = [[[NSMutableString alloc] init] autorelease];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        if (chars[i] < 16) {
            [hexString appendString:[NSString stringWithFormat:@"0%x", chars[i]]];
        } else {
            [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
        }
    }
    free(chars);
    
    return [[[NSString alloc] initWithString: hexString] autorelease];
}
 
 
- (NSString *)getPinCode:(int)iLength :(NSString *)theString {
    
    int n = [theString length];
    signed int h = 0;
    for (int i = 0; i < n; i++) {
        NSNumber *charVal = [[NSNumber alloc] initWithUnsignedShort:[theString characterAtIndex:i]];
        h = 31*h + [charVal intValue];
            }
    
    if (h < 0) h = h * -1;
    
    char p[20];
    sprintf(p, "%08i", h);
    char passcode[50];
    strcpy(passcode,&p[strlen(p) - iLength]);
    return [[NSString alloc] initWithCString:passcode encoding:NSASCIIStringEncoding];
    
}

-(NSString *) getDecimalStringFromHexString:(NSString *)theString {
    
    return [[[NSString alloc]initWithString:[theString stringFromHex]] autorelease];
    
}

@end
