//
//  NSString+hexWork.h
//  testEncryption
//
//  Created by Simon Hagger on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (hexWork)
- (NSString *) stringFromHex;
- (NSString *) stringToHex;
- (NSString *) getPinCode:(int)iLength:(NSString *)theString;
- (NSString *) getDecimalStringFromHexString:(NSString *)theString;
@end
