//
//  ScanCodeHelper.m
//  AccessOne
//
//  Created by khurram on 22/02/2013.
//
//

#import "ScanCodeHelper.h"
#import "AppSettings.h"
#import "QRStorage.h"
#import "NSData+CommonCrypto.h"
#import "NSData+hexReturn.h"
#import "NSString+hexWork.h"

@implementation ScanCodeHelper
@synthesize delegate;

//UserKey:a1test:asim:y:4:9:602a19ddd02cba1f2aab69c495b34fab:http%3A%2F%2F116.58.50.114%3A9632%2FLogin%2Frest%2Fworkflow%2Fqrauthtest

- (BOOL)scanKeyWithResultingString:(NSString *)result {
    NSString *qrResult = result;
    
    NSLog(@"Key string: %@", qrResult);
        
    BOOL scanResult = NO;
    NSString *registrationName = @"";
    NSString *applicationKey = @"";
    BOOL pinRequired = NO;
    NSInteger pinLengthInt = 4;
    NSInteger resetCount = 0;
    //Short bar codes terminator
    if ([qrResult length] < 16) {
        return scanResult;
    }
    
    bool isKey = false;
    
    NSString *QRIdentifier = [qrResult substringToIndex:15];
    
    NSLog(@"Substring to index 15: %@",QRIdentifier);
    
    if ([[QRIdentifier substringToIndex:7] caseInsensitiveCompare:@"UserKey"] == NSOrderedSame) {
        
    } else {
        return scanResult;
    }
    
    NSString *QRAppNameString = nil;
    NSString *QRUserNameString = @"";
    NSString *QRKeyString = @"";
    NSString *authenticationUrl = @"";
    
    
    //Get the message strings into an array
    NSArray *QRArray = [qrResult componentsSeparatedByString:@":"];
    if ([QRArray count] == 8) {
        isKey = true;
        QRAppNameString = [QRArray objectAtIndex:1];
        QRUserNameString = [QRArray objectAtIndex:2];
        QRKeyString = [QRArray objectAtIndex:6];
        authenticationUrl = [QRArray objectAtIndex:7];
        NSString *pinState = [QRArray objectAtIndex:3];
        NSString *pinLength = [QRArray objectAtIndex:4];
        NSString *pinRetriesCount = [QRArray objectAtIndex:5];
        pinRequired = ([pinState caseInsensitiveCompare:@"y"] == NSOrderedSame) ? YES : NO;
        pinLengthInt = [pinLength integerValue];
        if (!((pinLengthInt == 4) || (pinLengthInt == 6) || (pinLengthInt == 8))) {
            pinLengthInt = 4;
        }
        
        if (pinRetriesCount.length > 0) {
            if ([pinRetriesCount intValue] > 9) {
                return scanResult;
                isKey = NO;
            }
            else {
                resetCount = ([pinRetriesCount intValue] > 9) ? 9 : [pinRetriesCount intValue];
            }
        }
    }
    
    if (isKey) {
        scanResult = YES;
        registrationName = QRAppNameString;
        
        applicationKey = QRKeyString;
        
        if ([self.delegate respondsToSelector:@selector(scanCodeHelper:keyScannedWithRegisterationName:userName:applicationKey:authenticationUrl:pinRequired:pinLength:resetCount:googleSecret:)]) {
            [self.delegate scanCodeHelper:self keyScannedWithRegisterationName:registrationName userName:QRUserNameString applicationKey:applicationKey authenticationUrl:authenticationUrl pinRequired:pinRequired pinLength:pinLengthInt resetCount:resetCount  googleSecret:@"Not configured"];
            
            
        }
        return scanResult;
    }
    
    return scanResult;
}

- (NSString*)loadApplicationKey {
    NSString *filePath = [[AppSettings sharedAppSettings] dataFilePath];
    NSString *key = @"";
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[[NSMutableData alloc] initWithContentsOfFile:[[AppSettings sharedAppSettings] dataFilePath]] autorelease];
        NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
        QRStorage *storage = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        key = storage.appKey;
    }
    return key;
}

- (void)generatePasscodeWithChallangeString:(NSString*)QRChallengeString challanegLength:(NSInteger)length {
    
    //testing yasir
    //QRChallengeString = @"uuhc3db7mc9cu2dtfrqh6ffkjd";
    //length = [QRChallengeString length];
    //end test
    
    NSString *key = [self loadApplicationKey];
    
    NSData *objectKey = [[NSData alloc] bytesFromHexString:key];
    
    //@Proper Encryption
    NSData *challengeAsData = [[NSData alloc] initWithData:[QRChallengeString dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSData *encryptionDataResponse = [[NSData alloc] initWithData:[challengeAsData AES256EncryptedDataUsingKey:objectKey error:nil]];
    
    NSString *encryptionStringResponseASCII = [[NSString alloc] initWithBytes:[encryptionDataResponse bytes] length:[encryptionDataResponse length] encoding:NSASCIIStringEncoding];
    
    NSString *encryptionStringResponseHex = [[NSString alloc] initWithString:[encryptionStringResponseASCII stringToHex]];
    
    NSLog(@"ASCII Encryption Response: %@",encryptionStringResponseASCII);
    NSLog(@"Hex Encryption Response: %@",encryptionStringResponseHex);
    
    //HASH
    
    NSString *passCode = [[NSString alloc] getPinCode:length:encryptionStringResponseHex];
    
    NSLog(@"Passcode Value : %@",passCode);
    
    if ([self.delegate respondsToSelector:@selector(scanCodeHelper:passCode:)]) {
        [self.delegate scanCodeHelper:self passCode:passCode];
    }
    
    [challengeAsData release];
    [encryptionDataResponse release];
    [encryptionStringResponseASCII release];
    [encryptionStringResponseHex release];
}

- (BOOL)scanChallengeCodeScanResult:(NSString *)result {
    NSString *qrResult = result;
    
    BOOL scanResult = NO;
    
    if ([qrResult length] < 16) {
        
        scanResult = NO;
        return scanResult;
    }
    
    NSString *QRIdentifier = [qrResult substringToIndex:15];
    
    NSLog(@"Substring to index 15: %@",QRIdentifier);
    
    if (![QRIdentifier caseInsensitiveCompare:@"QRyptoChallenge"] == NSOrderedSame) {
        scanResult = NO;
        return scanResult;
    }
    
    NSString *QRAppNameString = nil;
    NSString *QRChallengeString = @"";
    NSString *QRChallengeLengthString = @"";
    
    NSArray *QRArray = [qrResult componentsSeparatedByString:@":"];
    QRAppNameString = [QRArray objectAtIndex:2];
    QRChallengeString = [QRArray objectAtIndex:3];
    QRChallengeLengthString = [QRArray objectAtIndex:1];
    
    if ([QRArray count] == 4) {
        
        scanResult = YES;
        [self generatePasscodeWithChallangeString:QRChallengeString challanegLength:6];
        
    }
    return scanResult;
}


- (BOOL)scanKeyWithResultingStringWith8Perams:(NSString *)result {
    
    NSLog(@"KEY: %@", result);
    NSString *qrResult = result;
    
    BOOL scanResult = NO;
    NSString *registrationName = @"";
    NSString *applicationKey = @"";
    BOOL pinRequired = NO;
    NSInteger pinLengthInt = 4;
    NSInteger resetCount = 0;
    //Short bar codes terminator
    if ([qrResult length] < 16) {
        return scanResult;
    }
    
    bool isKey = false;
    
    NSString *QRIdentifier = [qrResult substringToIndex:15];
    
    NSLog(@"Substring to index 15: %@",QRIdentifier);
    
    if ([[QRIdentifier substringToIndex:7] caseInsensitiveCompare:@"UserKey"] == NSOrderedSame) {
        
    } else {
        return scanResult;
    }
    
    NSString *QRAppNameString = nil;
    NSString *QRUserNameString = @"";
    NSString *QRKeyString = @"";
    
    //Get the message strings into an array
    NSArray *QRArray = [qrResult componentsSeparatedByString:@":"];
    if ([QRArray count] == 7) {
        isKey = true;
        QRAppNameString = [QRArray objectAtIndex:1];
        QRUserNameString = [QRArray objectAtIndex:2];
        QRKeyString = [QRArray objectAtIndex:6];
        NSString *pinState = [QRArray objectAtIndex:3];
        NSString *pinLength = [QRArray objectAtIndex:4];
        NSString *pinRetriesCount = [QRArray objectAtIndex:5];
        pinRequired = ([pinState caseInsensitiveCompare:@"y"] == NSOrderedSame) ? YES : NO;
        pinLengthInt = [pinLength integerValue];
        if (!((pinLengthInt == 4) || (pinLengthInt == 6) || (pinLengthInt == 8))) {
            pinLengthInt = 4;
        }
        
        if (pinRetriesCount.length > 0) {
            if ([pinRetriesCount intValue] > 9) {
                return scanResult;
                isKey = NO;
            }
            else {
                resetCount = ([pinRetriesCount intValue] > 9) ? 9 : [pinRetriesCount intValue];
            }
        }
        
    }
    
    if (isKey) {
        scanResult = YES;
        registrationName = QRAppNameString;
        
        applicationKey = QRKeyString;
        
        if ([self.delegate respondsToSelector:@selector(scanCodeHelper:keyScannedWithRegisterationName:userName:applicationKey:pinRequired:pinLength:resetCount:)]) {
            [self.delegate scanCodeHelper:self keyScannedWithRegisterationName:registrationName userName:QRUserNameString applicationKey:applicationKey pinRequired:pinRequired pinLength:pinLengthInt resetCount:resetCount];
        }
        return scanResult;
    }
    
    return scanResult;
}


- (BOOL)scanChallengeCodeScanResultFor8Perams:(NSString *)result {
    NSLog(@"Challenge: %@", result);
    NSString *qrResult = result;
    
    BOOL scanResult = NO;
    
    if ([qrResult length] < 16) {
        
        scanResult = NO;
        return scanResult;
    }
    
    NSString *QRIdentifier = [qrResult substringToIndex:15];
    
    NSLog(@"Substring to index 15: %@",QRIdentifier);
    
    if (![QRIdentifier caseInsensitiveCompare:@"QRyptoChallenge"] == NSOrderedSame) {
        scanResult = NO;
        return scanResult;
    }
    
    NSString *QRAppNameString = nil;
    NSString *QRChallengeString = @"";
    NSString *QRChallengeLengthString = @"";
    
    NSArray *QRArray = [qrResult componentsSeparatedByString:@":"];
    if ([QRArray count] == 4) {
        QRAppNameString = [QRArray objectAtIndex:2];
        QRChallengeString = [QRArray objectAtIndex:3];
        QRChallengeLengthString = [QRArray objectAtIndex:1];
        
        scanResult = YES;
        [self generatePasscodeWithChallangeString:QRChallengeLengthString challanegLength:6];
//        NSString *key = [self loadApplicationKey];
//        
//        NSData *objectKey = [[NSData alloc] bytesFromHexString:key];
//        
//        //@Proper Encryption
//        NSData *challengeAsData = [[NSData alloc] initWithData:[QRChallengeString dataUsingEncoding:NSASCIIStringEncoding]];
//        
//        NSData *encryptionDataResponse = [[NSData alloc] initWithData:[challengeAsData AES256EncryptedDataUsingKey:objectKey error:nil]];
//        
//        NSString *encryptionStringResponseASCII = [[NSString alloc] initWithBytes:[encryptionDataResponse bytes] length:[encryptionDataResponse length] encoding:NSASCIIStringEncoding];
//        
//        NSString *encryptionStringResponseHex = [[NSString alloc] initWithString:[encryptionStringResponseASCII stringToHex]];
//        
//        NSLog(@"ASCII Encryption Response: %@",encryptionStringResponseASCII);
//        NSLog(@"Hex Encryption Response: %@",encryptionStringResponseHex);
//        
//        //HASH
//        
//        NSString *passCode = [[NSString alloc] getPinCode:[QRChallengeLengthString intValue]:encryptionStringResponseHex];
//        
//        NSLog(@"Passcode Value : %@",passCode);
//        
//        if ([self.delegate respondsToSelector:@selector(scanCodeHelper:passCode:)]) {
//            [self.delegate scanCodeHelper:self passCode:passCode];
//        }
//        
//        [challengeAsData release];
//        [encryptionDataResponse release];
//        [encryptionStringResponseASCII release];
//        [encryptionStringResponseHex release];
        
        return scanResult;
    }
    return scanResult;
}




@end
