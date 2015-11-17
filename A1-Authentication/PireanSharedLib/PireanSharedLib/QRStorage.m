//
//  QRStorage.m
//  QryptoLogin
//
//  Created by Simon on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QRStorage.h"

#define kAppKey @"AppKey"

@implementation QRStorage

@synthesize appKey;
    
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:appKey forKey:kAppKey];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        appKey = [decoder decodeObjectForKey:kAppKey];
    }
    return self;
}
#pragma mark -
#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone {
    QRStorage *copy = [[[[self class] allocWithZone:zone] init] autorelease];
    copy.appKey = [self.appKey copyWithZone:zone];
    return copy; // Added by Ubaid
}


@end
