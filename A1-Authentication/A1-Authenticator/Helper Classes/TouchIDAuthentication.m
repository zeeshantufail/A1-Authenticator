//
//  TouchIDAuthentication.m
//  SelfServicePortal
//
//  Created by Zeeshan Tufail on 28/08/2014.
//
//

#import "TouchIDAuthentication.h"
#import <AvailabilityInternal.h>
#import "AppSettings.h"

@implementation TouchIDAuthentication


-(void)setUpAuthenticationWithMessageString: (NSString *)message andFallbackTitle: (NSString *)fallback{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    LAContext *myContext = nil;
    @try {
        
        myContext = [[LAContext alloc] init];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    myContext.localizedFallbackTitle = fallback;
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:message reply:^(BOOL success, NSError *error){
            if (success) {
                
                if ([self.delegate respondsToSelector:@selector(touchIDSuccess:)]) {
                    [self.delegate touchIDSuccess:self];
                }
            }
            else{
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorAuthFailed:)]) {
                            [self.delegate touchIDErrorAuthFailed:self];
                        }
                        break;
                    case LAErrorPasscodeNotSet:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorPasscodeNotSet:)]) {
                            [self.delegate touchIDErrorPasscodeNotSet:self];
                        }
                        break;
                    case LAErrorSystemCancel:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorSystemCancel:)]) {
                            [self.delegate touchIDErrorSystemCancel:self];
                        }
                        break;
                    case LAErrorTouchIDNotAvailable:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorTouchIDNotAvailable:)]) {
                            [self.delegate touchIDErrorTouchIDNotAvailable:self];
                        }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorTouchIDNotEnrolled:)]) {
                            [self.delegate touchIDErrorTouchIDNotEnrolled:self];
                        }
                        break;
                    case LAErrorUserCancel:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorUserCancel:)]) {
                            [self.delegate touchIDErrorUserCancel:self];
                        }
                        break;
                    case LAErrorUserFallback:
                        if ([self.delegate respondsToSelector:@selector(touchIDErrorUserFallback:)]) {
                            [self.delegate touchIDErrorUserFallback:self];
                        }
                        break;
                        
                    default:
                        break;
                }
            }
            
        }];
    }
    else{
        
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Device error" message:@"Touch id not available for this device" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] autorelease];
//        [alert show];
        if ([self.delegate respondsToSelector:@selector(touchIDDeviceError:)]) {
            [self.delegate touchIDDeviceError:self];
        }
    }
#else
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"iOS version error" message:@"Minimum ios 8 is required for touch ID" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] autorelease];
    [alert show];
    if ([self.delegate respondsToSelector:@selector(touchIDDeviceError:)]) {
        [self.delegate touchIDDeviceError:self];
#endif
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(touchIDDeviceError:)]) {
                [self.delegate touchIDDeviceError:self];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"proceedToHomeView" object:nil];
            break;
            
        default:
            break;
    }
}

-(BOOL)touchIDAvailable{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    LAContext *myContext = nil;
    @try {
        
        myContext = [[LAContext alloc] init];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        return YES;
    }
#endif
    return NO;
}

@end
