//
//  AppHelper.m
//
//
//  Created by Waqar on 11/2/15.
//
//

#import "AppHelper.h"
#import "AppSettings.h"
#import <AvailabilityInternal.h>
#import <sys/utsname.h>
#import "TouchIDAuthentication.h"
#import "OTPAuthURL.h"
#import "OTPAuthURLEntryController.h"


@implementation AppHelper

static AppHelper *instance;
static CGFloat timerCount = 0;
+(AppHelper *)sharedInstance{
    if (instance == nil) {
        instance = [[AppHelper alloc] init];
    }
    return instance;
}

+ (BOOL)isIPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIphone5 {
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

+ (BOOL)isIphone4 {
    return ([[UIScreen mainScreen] bounds].size.height == 480);
}

+ (BOOL)isIphone6 {
    return ([[UIScreen mainScreen] bounds].size.height == 667);
}

+ (BOOL)isIphone6p {
    return ([[UIScreen mainScreen] bounds].size.height == 736);
}

+(BOOL)isIOS8{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0;
}

+(BOOL)isDeviceTouchIDSetup{
    return [[[TouchIDAuthentication alloc] init]  touchIDAvailable];
}

+(NSString *)getStoryboardName
{
    NSString *storyboard;
    
    if ([self isIphone6p])
    {
        storyboard = @"StoryBoard_iphone6Plus";
    }
    else if ([self isIphone6])
    {
        storyboard = @"StoryBoard_iPhone6";
    }
    else
    {
        storyboard = @"Main";                   // iphone 5,5s
    }
    
    return storyboard;
}

+(void)saveAction:(NSString *)action
{
    NSMutableArray *tempArray;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"AuditHistory"])
    {
        tempArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AuditHistory"] mutableCopy];
    }
    else
    {
        tempArray = [[NSMutableArray alloc] init];
    }
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [self getCurrentDateAndTime],@"datetime",
                           action,@"action",
                           nil];
    
    [tempArray addObject:dict];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"AuditHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) getCurrentDateAndTime
{
    NSDate   * crntDate;
    NSString * currentDateTime;
    
    crntDate = [NSDate date];
    
    currentDateTime = [self getStringFromDate:crntDate];
    
    return currentDateTime;
}

+(NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}

+(void)showTouchScanWithMessage: (NSString *)message fallBackString: (NSString *)fallbackMessage{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
    LAContext *myContext = [[LAContext alloc] init];
    myContext.localizedFallbackTitle = fallbackMessage;
    NSError *authError = nil;
    //NSString *message = @"Please place your finger to test touch id";
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message reply:^(bool success, NSError *error){
            if (success) {
                //self.touchMessageLbl.text = @"success";
            }
            else{
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        
                        //self.touchMessageLbl.text = @"Authentication failed";
                        break;
                    case LAErrorPasscodeNotSet:
                        
                        //self.touchMessageLbl.text = @"No passcode set";
                        break;
                    case LAErrorSystemCancel:
                        
                        //self.touchMessageLbl.text = @"System cancle";
                        break;
                    case LAErrorTouchIDNotAvailable:
                        
                        //self.touchMessageLbl.text = @"Touch id not available";
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        
                        //self.touchMessageLbl.text = @"Touch id not enrolled";
                        break;
                    case LAErrorUserCancel:
                        
                        //self.touchMessageLbl.text = @"User cancel";
                        break;
                    case LAErrorUserFallback:
                        
                        //self.touchMessageLbl.text = @"Enter password";
                        break;
                        
                    default:
                        break;
                }
            }
            
        }];
    }
#endif
}

-(NSString* )machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
+ (void)presentNavController:(UINavigationController*)navController overNavController:(UINavigationController*)overNavController animated:(BOOL)animated {
    if ([overNavController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [overNavController presentViewController:navController animated:animated completion:nil];
    }
    else {
        [overNavController presentModalViewController:navController animated:animated];
    }
}

+ (void)dismissViewController:(UIViewController*)viewController animated:(BOOL)animated {
    if ([viewController respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [viewController dismissViewControllerAnimated:animated completion:nil];
    }
    else {
        [viewController dismissModalViewControllerAnimated:animated];
    }
    
}

+(void)connectionFailedNotification{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomBarStopAnimating) name:@"connectionFailedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionFailedNotification" object:nil];
}

-(void)authenticateUserNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self performSelector:@selector(authenticateDelay) withObject:nil afterDelay:1];
    });
}

-(void)authenticateDelay{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"authenticateUserNotification" object:nil];
}

#pragma mark - Google authentication methods

static OTPAuthURL * authUrl;

+(NSString *)getGooglePasscode{
    if (!authUrl) {
        NSString * secret = [[AppSettings sharedAppSettings] googleSecret];
        if (secret) {
            authUrl = [[[OTPAuthURLEntryController alloc] init] getAuthUrlFromSecret:secret];
        }
    }
    if (authUrl) {
        return authUrl.checkCode;
    }
    else{
        return nil;
    }
}


+(CGFloat)lockScreenDuration{
    return 30;
}

+(void)setLockScreenDuration:(CGFloat)count{
    timerCount = count;
}

static bool shouldChellangeAuthentication = true;

+(BOOL)shouldChellangeAuthentication{
    return shouldChellangeAuthentication;
}

+(void)setShouldChellangeAuthentication:(BOOL)flag{
    shouldChellangeAuthentication = flag;
}

@end

