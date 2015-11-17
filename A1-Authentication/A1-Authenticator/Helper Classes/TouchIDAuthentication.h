//
//  TouchIDAuthentication.h
//  SelfServicePortal
//
//  Created by Zeeshan Tufail on 28/08/2014.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#import <LocalAuthentication/LocalAuthentication.h>
#endif

#define mCONFIRM_TOUCH_ID 1
#define mENTER_TOUCH_ID 2
@class TouchIDAuthentication;
@protocol TouchIDAuthenticationDelegate <NSObject>

-(void)touchIDSuccess: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorAuthFailed: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorPasscodeNotSet: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorSystemCancel: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorTouchIDNotAvailable: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorTouchIDNotEnrolled: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorUserCancel: (TouchIDAuthentication*)touchID;
-(void)touchIDErrorUserFallback: (TouchIDAuthentication*)touchID;
-(void)touchIDDeviceError: (TouchIDAuthentication*)touchID;

@end

@interface TouchIDAuthentication : NSObject<UIAlertViewDelegate>

enum TouchIDType{
    CONFIRM_TOUCH_ID = mCONFIRM_TOUCH_ID,
    ENTER_TOUCH_ID = mENTER_TOUCH_ID
};

@property (retain) id<TouchIDAuthenticationDelegate> delegate;
@property enum TouchIDType touchIDType;
-(void)setUpAuthenticationWithMessageString: (NSString *)message andFallbackTitle: (NSString *)fallback;
-(BOOL)touchIDAvailable;

@end
