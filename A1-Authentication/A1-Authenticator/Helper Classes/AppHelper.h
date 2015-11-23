//
//  AppHelper.h
//
//
//  Created by Waqar on 11/2/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppHelper : NSObject

+ (BOOL)isIPad;
+ (BOOL)isIphone4;
+ (BOOL)isIphone5;
+ (BOOL)isIphone6;
+ (BOOL)isIphone6p;
+(BOOL)isIOS8;
+(BOOL)isDeviceTouchIDSetup;
+(void)showTouchScanWithMessage: (NSString *)message;
+ (void)dismissViewController:(UIViewController*)viewController animated:(BOOL)animated;
+ (void)presentNavController:(UINavigationController*)navController overNavController:(UINavigationController*)overNavController animated:(BOOL)animated;
+(void)connectionFailedNotification;
-(void)authenticateUserNotification;

+(AppHelper*) sharedInstance;
+(NSString *)getGooglePasscode;

+(CGFloat)lockScreenDuration;
+(void)setLockScreenDuration:(CGFloat)count;


+(BOOL)shouldChellangeAuthentication;
+(void)setShouldChellangeAuthentication:(BOOL)flag;
@end
