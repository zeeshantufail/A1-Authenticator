//
//  ScanCodeHelper.h
//  AccessOne
//
//  Created by khurram on 22/02/2013.
//
//

#import <Foundation/Foundation.h>
@class ScanCodeHelper;

@protocol ScanCodeHelperProtocol <NSObject>

@optional
- (void)scanCodeHelper:(ScanCodeHelper*)scanCodeHelper keyScannedWithRegisterationName:(NSString*)regName userName:(NSString*)userName applicationKey:(NSString*)key authenticationUrl:(NSString*)url pinRequired:(BOOL)pinRequired pinLength:(NSInteger)pinLength resetCount:(NSInteger)resetCount googleSecret:(NSString *) secret;
- (void)scanCodeHelper:(ScanCodeHelper*)scanCodeHelper passCode:(NSString*)passCode;

@end

@interface ScanCodeHelper : NSObject
{
    id <ScanCodeHelperProtocol> delegate;
}

@property (nonatomic, assign) id <ScanCodeHelperProtocol> delegate;

- (BOOL)scanKeyWithResultingString:(NSString *)result;
- (BOOL)scanChallengeCodeScanResult:(NSString *)result;
- (void)generatePasscodeWithChallangeString:(NSString*)QRChallengeString challanegLength:(NSInteger)length;
- (BOOL)scanKeyWithResultingStringWith8Perams:(NSString *)result;
- (BOOL)scanChallengeCodeScanResultFor8Perams:(NSString *)result;

@end
