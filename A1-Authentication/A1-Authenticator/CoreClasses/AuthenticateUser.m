//
//  AuthenticateUser.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 05/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "AuthenticateUser.h"
#import "Reachability.h"

@implementation AuthenticateUser

-(void)authenticateUser{
    if ([self internetConnected]) {
        [self startAuthentication];
    }
    else{
        NSLog(@"No Internet");// todo zeeshan
    }
}


- (void)startAuthentication {
    if(![self internetConnected])
        return;
    if (!self.authenticationHelper)
        self.authenticationHelper = [[A1AuthenticationHelper alloc] init];
    self.authenticationHelper.delegate = self;
    //[self.authenticationHelper authenticateUser];
    [self.authenticationHelper performSelector:@selector(authenticateUser) withObject:nil afterDelay:0.5];
}


- (BOOL)internetConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


-(void)authenticationHelperPassCodeVerified:(AuthenticationHelper *)authenticationHelper{
    [self.delegate userAuthenticatedSuccessfully:self];
}

-(void)qrAuthenticationFailed{
    [self.delegate userAuthenticationFailed:self];
}

-(void)passCodeAuthenticationFailed{
    [self.delegate userAuthenticationFailed:self];
}
@end
