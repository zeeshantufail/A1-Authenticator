//
//  NSData+hexReturn.h
//  Hex-and-Bytes
//
//  Created by Simon on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (hexReturn)
    -(NSData*) bytesFromHexString:(NSString *)aString;
@end
