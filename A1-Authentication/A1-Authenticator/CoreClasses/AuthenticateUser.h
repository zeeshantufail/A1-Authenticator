//
//  AuthenticateUser.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 05/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "A1AuthenticationHelper.h"
#import "GravatarLoader.h"

@class AuthenticateUser;
@protocol AuthenticateUserDelegate <NSObject>

-(void)userAuthenticatedSuccessfully:(AuthenticateUser *)authenticateUser;
-(void)userAuthenticationFailed:(AuthenticateUser *)authenticateUser;

@end

@interface AuthenticateUser : NSObject<AuthenticationHelperProtocol, GravatarLoaderDelegate>

@property (nonatomic) A1AuthenticationHelper * authenticationHelper;
@property (nonatomic) id<AuthenticateUserDelegate> delegate;
-(void)authenticateUser;

@end


