//
//  AppSettings.h
//  AccessOne
/*
 * AppSettings.h
 * This file belongs to A1 Application
 * Copyright (R) Pirean.com. All rights reserved
 * Version 1.0
 * Last updated: Jan 28, 2013
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

#define PinKey @"AppPinKey"
#define ActivationKey @"ABC"
#define kFilename @"archive"
#define kDataKey @"Data"

//added by zeeshan
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface AppSettings : NSObject{
    AVAudioPlayer * pSound;
    NSURL *soundFile;
}


+ (AppSettings*)sharedAppSettings;
+ (NSString*)languageStringForKey:(NSString*)key;

- (NSString *)dataFilePath;
- (BOOL)checkPin:(NSString*)pin;
- (void)setAppPin:(NSString*)pin;
- (NSString*)getDeviceName;
- (NSString*)getDeviceVersion;
- (NSString*)getDeviceId;
- (NSString*)getDeviceBrowser;
- (NSString*)getDeviceOS;
- (NSString*)getDeviceType;
- (NSString*)getDeviceColorDepth;
- (NSString*)getDeviceResolution;
- (BOOL)appPinState;
- (void)setAppPinState:(BOOL)setPin;
- (NSInteger)getPinLength;
- (void)setPinLength:(NSInteger)length;
- (void)setAppActivationState:(BOOL)appActivationState;
- (BOOL)appActivationState;
- (void)resetApplication;
//- (void)resetApplication:(NSManagedObjectContext *)moc;
- (void)setResetAppNum:(NSInteger)resetAppNum;
- (NSInteger)resetAppNum;
- (void)setAppRegName:(NSString*)appRegName;
- (NSString*)appRegName;
- (BOOL)isResetAppCountEnable;
- (void)enableResetAppCount:(BOOL)enable;
- (void)setApplicationLanguage:(NSInteger)language;
- (NSInteger)applicationLanguage;
- (NSString*)applicationVersion;
- (NSBundle*)languageBundle;
- (void)setAppUserName:(NSString*)appUserName;
- (NSString*)appUserName;
- (void)setApplicationAuthenticationUrl:(NSString*)url;
- (NSString*)applicationAuthenticationUrl;
- (void)setQRChanllangeCode:(NSString*)challangeCode;
- (NSString*)qrChanllangeCode;
- (void)setWebtopInitialUrl:(NSString*)url;
- (NSString*)webtopInitialUrl;
- (void)setA1SessionCookie:(NSString*)sessionCookie;
- (NSString*)a1SessionCookie;
- (void)setAppPinCreated:(BOOL)pinCreated;
- (BOOL)appPinCreated;
-(void)setAppTouchID:(BOOL)touchID;
-(BOOL)appTouchID;

-(void)playPositiveSound;
-(void)playNegativeSound;
-(void)setConfirmTouchID:(BOOL)touchID;
-(BOOL)confirmTouchID;
//added by zeeshan

- (NSString*)appUserFirstName;
- (NSString*)appUserLastName;
- (void)setAppUserFirstName:(NSString *)firstName;
- (void)setAppUserLastName:(NSString *)lastName;

-(NSString *)googleSecret;
- (void)setGoogleSecret:(NSString *)secret;

- (BOOL)appTotp;
- (void)setAppTotp:(BOOL)totp;
-(void)setPassCodeFailCount:(NSInteger)count;
-(NSInteger)passCodeFailCount;

-(void)setLockScreenTimerCount:(double)count;
-(double)lockScreenTimerCount;



@property (strong) id refrenceHolder;
@property (strong) id rootController;

@end
