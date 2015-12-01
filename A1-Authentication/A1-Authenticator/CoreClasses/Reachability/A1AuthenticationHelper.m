//
//  SSPAuthenticationHelper.m
//  SelfServicePortal
//
//  Created by Zeeshan Tufail on 23/04/2015.
//
//

#import "A1AuthenticationHelper.h"
#import "AppSettings.h"

@implementation A1AuthenticationHelper

- (void)authenticateUser {
    if(!self.httpService)
        self.httpService = [[A1HTTPService alloc] initWithDelegate:self];
        [self.httpService authenticateUser];
}

- (void)generatePasscodeWithChallangeCode:(NSString*)challanegCode {
    [[AppSettings sharedAppSettings] setQRChanllangeCode:challanegCode];
    ScanCodeHelper *scanCodeHelper = [[ScanCodeHelper alloc] init] ;
    scanCodeHelper.delegate = self;
    NSLog(@"%@ %@", challanegCode, [[AppSettings sharedAppSettings] qrChanllangeCode]);
    [scanCodeHelper generatePasscodeWithChallangeString:[[AppSettings sharedAppSettings] qrChanllangeCode] challanegLength:6];
}

//
//- (void)jsonHttpService:(JsonHttpService *)jsonHttpService responseCompleted:(NSMutableDictionary *)response {
//    
//    NSString *challangeCode = [response objectForKey:@"qrchallengecode"];
//    NSLog(@"ChallangeCode: %@", challangeCode);
//    
//    NSString *initialUrl = [response objectForKey:@"initialurl"];
//    NSLog(@"initialUrl = %@",initialUrl);
//    
//    NSString * userFirstName = [response objectForKey:@"firstname"];
//    NSString *userLastName = [response objectForKey:@"surname"];
//    
//    if (userFirstName.length > 0 && userLastName.length > 0) {
//        [[AppSettings sharedAppSettings] setAppUserFirstName:userFirstName];
//        [[AppSettings sharedAppSettings] setAppUserLastName:userLastName];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
//    }
//    
//    if (challangeCode) {
//        [self generatePasscodeWithChallangeCode:challangeCode];
//    }
//    else if (initialUrl) {
//        
//        NSString *qrResponseCode = [response objectForKey:@"qrresponsecode"];
//        if ([qrResponseCode isEqualToString:@"0000"])
//        {
//            
//            NSString *a1SessionCookie = [response objectForKey:@"a1_session_cookie"];
//            
//            [[AppSettings sharedAppSettings] setA1SessionCookie:a1SessionCookie];
//            [[AppSettings sharedAppSettings] setWebtopInitialUrl:initialUrl];
//            
//            if ([self.delegate respondsToSelector:@selector(authenticationHelperPassCodeVerified:)]) {
//                [self.delegate authenticationHelperPassCodeVerified:self];
//            }
//        }
//        else {
//            if([self.delegate respondsToSelector:@selector(passCodeAuthenticationFailed)])
//            {
//                [self.delegate passCodeAuthenticationFailed];
//            }
//        }
//    }
//    else {
//        if([self.delegate respondsToSelector:@selector(qrAuthenticationFailed)])
//            [self.delegate qrAuthenticationFailed];
//    }
//    
//}


@end
