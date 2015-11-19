//
//  AppSettings.m
//  AccessOne
//
//  Created by Muhammad Ubaid on 1/18/13.
//
//

#import "AppSettings.h"
#import "NSData+CommonCrypto.h"
#import "AppInfo.h"
//#import "MOCHelper.h"
#import <AVFoundation/AVFoundation.h>

static AppSettings *appSettings;

@implementation AppSettings

+ (AppSettings*)sharedAppSettings {
    if (!appSettings) {
        appSettings = [[AppSettings alloc] init];
        
    }
    return appSettings;
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)setAppPin:(NSString*)pin {
    
    NSData *pinData = [pin dataUsingEncoding:NSASCIIStringEncoding];
    NSData *hashData = [pinData SHA1Hash];
    
    [[NSUserDefaults standardUserDefaults] setValue:hashData forKey:@"Pin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
//    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
//    [archiver encodeObject:pin forKey:PinKey];
//    [archiver finishEncoding];
//    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"Pin"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)checkPin:(NSString*)pin {
    return true;//todo
    NSData *pinData = [pin dataUsingEncoding:NSASCIIStringEncoding];
    NSData *hashData = [pinData SHA1Hash];
    
    NSData *savedHash = [[NSUserDefaults standardUserDefaults] valueForKey:@"Pin"];
    return [hashData isEqualToData:savedHash];
}

- (BOOL)appPinState {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"PinState"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    // NSNumber *pinState = [unarchiver decodeObjectForKey:PinKey];
    NSString *number = [unarchiver decodeObjectForKey:PinKey];
    float pinState = [number  isEqual: @"a"] ? 1 : 0 ;
    [unarchiver finishDecoding];
    if (!pinState) {
        return NO;
    }
    else
        //return [pinState boolValue];
        return YES;
}

- (void)setAppPinState:(BOOL)pinState {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    //[archiver encodeObject:[NSNumber numberWithBool:pinState] forKey:PinKey];
    [archiver encodeObject:[NSString stringWithFormat:@"%@", pinState ? @"a" : @"b" ] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"PinState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self appPinState];
}

-(void)setAppTouchID:(BOOL)touchID{
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    //[archiver encodeObject:[NSNumber numberWithBool:pinState] forKey:PinKey];
    [archiver encodeObject:[NSString stringWithFormat:@"%@", touchID ? @"a" : @"b" ] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"TouchID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self appTouchID];
}

- (BOOL)appTouchID {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"TouchID"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    // NSNumber *pinState = [unarchiver decodeObjectForKey:PinKey];
    NSString *number = [unarchiver decodeObjectForKey:PinKey];
    float pinState = [number  isEqual: @"a"] ? 1 : 0 ;
    [unarchiver finishDecoding];
    if (!pinState) {
        return NO;
    }
    else
        //return [pinState boolValue];
        return YES;
}

-(void)setConfirmTouchID:(BOOL)touchID{
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    //[archiver encodeObject:[NSNumber numberWithBool:pinState] forKey:PinKey];
    [archiver encodeObject:[NSString stringWithFormat:@"%@", touchID ? @"a" : @"b" ] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"ConfirmTouchID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self appTouchID];
}

- (BOOL)confirmTouchID {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"ConfirmTouchID"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    // NSNumber *pinState = [unarchiver decodeObjectForKey:PinKey];
    NSString *number = [unarchiver decodeObjectForKey:PinKey];
    float pinState = [number  isEqual: @"a"] ? 1 : 0 ;
    [unarchiver finishDecoding];
    if (!pinState) {
        return NO;
    }
    else
        //return [pinState boolValue];
        return YES;
}

- (BOOL)appPinCreated {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"PinCreated"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSNumber *pinCreated = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    if (!pinCreated) {
        return NO;
    }
    else
        return [pinCreated boolValue];
}

- (void)setAppPinCreated:(BOOL)pinCreated {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:[NSNumber numberWithBool:pinCreated] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"PinCreated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getPinLength {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"PinLength"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSNumber *pinState = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    if (!pinState) {
        return 4;
    }
    else
        return [pinState integerValue];
}

- (void)setPinLength:(NSInteger)length {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:[NSNumber numberWithInt:length] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"PinLength"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)appActivationState {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"appActivationState"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    // NSNumber *pinState = [unarchiver decodeObjectForKey:PinKey];
    NSString *number = [unarchiver decodeObjectForKey:PinKey];
    NSLog(@"%@", number);
    float pinState = [number  isEqual: @"a"] ? 1 : 0 ;
    [unarchiver finishDecoding];
    if (!pinState) {
        return NO;
    }
    else
        //return [pinState boolValue];
        return YES;
}

- (void)setAppActivationState:(BOOL)appActivationState {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    //[archiver encodeObject:[NSNumber numberWithBool:appActivationState] forKey:PinKey];
    [archiver encodeObject:[NSString stringWithFormat:@"%@", appActivationState ? @"a" : @"b" ] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"appActivationState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self appActivationState];
}

- (NSInteger)resetAppNum {
    //    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"ResetAppNum"];
    //    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    //    NSNumber *resetAppNum = [unarchiver decodeObjectForKey:PinKey];
    //    [unarchiver finishDecoding];
    //if (!resetAppNum) {
    return 9;
    //}
    //else
    //return [resetAppNum integerValue];
}

- (void)setResetAppNum:(NSInteger)resetAppNum {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:[NSNumber numberWithInt:resetAppNum] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"ResetAppNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)enableResetAppCount:(BOOL)enable {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:[NSNumber numberWithBool:enable] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"ResetEnable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isResetAppCountEnable {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"ResetEnable"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSNumber *resetEnabled = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    if (!resetEnabled) {
        return YES;
    }
    else
        return [resetEnabled boolValue];
}

- (void)resetApplication {
    [self setAppActivationState:NO];
    [self setAppPinState:NO];
    [self setAppPinCreated:NO];
    [self setPinLength:0];
    [self setResetAppNum:0];
    [self enableResetAppCount:YES];
    [self setAppTouchID:NO];
    [self setApplicationLanguage:0];
    [self setAppUserFirstName:@""];
    [self setAppUserLastName:@""];
    [self setAppPin:@"****"];
    
    
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    //[AppInfo deleteAllObjects:[[MOCHelper sharedMOCHelper] getMOC]];
}

- (NSString*)getDeviceName {
    return [[UIDevice currentDevice] name];
}

- (NSString*)getDeviceVersion {
    return [[UIDevice currentDevice] localizedModel];
}

- (NSString*)generateDeviceId {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

- (NSString*)getDeviceResolution {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    return [NSString stringWithFormat:@"%fX%f", screenWidth, screenHeight];
}

- (NSString*)getDeviceColorDepth {
    return @"32 bit";
}

- (NSString*)getDeviceType {
    return @"Mobile";
}

- (NSString*)getDeviceOS {
    return [NSString stringWithFormat:@"IOS %@", [[UIDevice currentDevice] systemVersion]];
}

- (NSString*)getDeviceBrowser {
    return @"Self Service Portal";
}

- (NSString*)getDeviceId {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceId"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *deviceId = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    if (!deviceId) {
        deviceId = [self generateDeviceId];
        [self setDeviceId:deviceId];
    }
    return deviceId;
}

- (void)setDeviceId:(NSString*)deviceId {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:deviceId forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"DeviceId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)appRegName {
    
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppRegName"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *appName = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return appName;
}

- (void)setAppRegName:(NSString*)appRegName {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:appRegName forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"AppRegName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)applicationAuthenticationUrl {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"ApplicationAuthenticationUrl"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *url = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return url;
}

- (void)setApplicationAuthenticationUrl:(NSString*)url {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:url forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"ApplicationAuthenticationUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)webtopInitialUrl {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"WebtopInitialUrl"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *url = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return url;
}

- (void)setWebtopInitialUrl:(NSString*)url {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:url forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"WebtopInitialUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)qrChanllangeCode {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"qrChanllangeCode"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *challangeCode = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return challangeCode;
}

- (void)setQRChanllangeCode:(NSString*)challangeCode {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:challangeCode forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"qrChanllangeCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)appUserName {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserName"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *appName = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return appName;
}



- (NSString*)appUserFirstName {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserFirstName"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *appName = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return appName;
}

- (NSString*)appUserLastName {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppUserLastName"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *appName = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return appName;
}

- (void)setAppUserFirstName:(NSString *)firstName {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:firstName forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"AppUserFirstName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAppUserLastName:(NSString *)lastName {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:lastName forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"AppUserLastName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)setAppUserName:(NSString*)appUserName {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:appUserName forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"AppUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)applicationLanguage {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppLanguage"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSNumber *language = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    if (!language) {
        return 0;
    }
    else
        return [language integerValue];
}

- (void)setApplicationLanguage:(NSInteger)language {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:[NSNumber numberWithInt:language] forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"AppLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)a1SessionCookie {
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"A1SessionCookie"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *sessionCookie = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return sessionCookie;
}

- (void)setA1SessionCookie:(NSString*)sessionCookie {
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:sessionCookie forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"A1SessionCookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)titleFontSize {
    return 38;
}

- (NSString*)applicationVersion {
    NSString *version =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    return version;
}

- (NSBundle*)languageBundle {//todo zeeshan
    //    NSString *bundlePath = nil;
    //    if ([[AppSettings sharedAppSettings] applicationLanguage] == 0) {
    //        bundlePath = [[NSBundle mainBundle] pathForResource:EN_LANGUAGE ofType:@"lproj"];
    //    }
    //    else/* if ([[AppSettings sharedAppSettings] applicationLanguage] == 1)*/ {
    //        bundlePath = [[NSBundle mainBundle] pathForResource:FR_LANGUAGE ofType:@"lproj"];
    //    }
    //
    //    NSBundle* languageBundle = [NSBundle bundleWithPath:bundlePath];
    //    return languageBundle;
    return nil;
}

+ (NSString*)languageStringForKey:(NSString*)key {
    return [[[AppSettings sharedAppSettings] languageBundle] localizedStringForKey:key value:@"" table:nil];
}

-(void)playPositiveSound{
    @try {
        
        soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Positive" ofType:@"wav"]];
    }
    @catch (NSException *exception) {
        return;
    }
    pSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:nil];
    [pSound setVolume:1.0];
    //[pSound preparetoPlay];
    [pSound play];
}

-(void)playNegativeSound{
    @try {
        
        soundFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Negative" ofType:@"wav"]];
    }
    @catch (NSException *exception) {
        return;
    }
    if (!soundFile) {
        return;
    }
    pSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:nil];
    [pSound setVolume:1.0];
    //[pSound preparetoPlay];
    [pSound play];
}



-(NSString *)googleSecret{
    
    NSMutableData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"GoogleSecret"];
    NSKeyedUnarchiver *unarchiver = [[[NSKeyedUnarchiver alloc] initForReadingWithData:data] autorelease];
    NSString *googleSecret = [unarchiver decodeObjectForKey:PinKey];
    [unarchiver finishDecoding];
    return googleSecret;
}
- (void)setGoogleSecret:(NSString *)secret{
    
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    NSKeyedArchiver *archiver = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:data] autorelease];
    [archiver encodeObject:secret forKey:PinKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"GoogleSecret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
