//
//  AuthenticationHelper.h
//  RMAWebTop
//
//  Created by khurram on 04/06/2013.
//  Copyright (c) 2013 Intagleo Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonHttpService.h"
#import "ScanCodeHelper.h"

@class AuthenticationHelper;

@protocol AuthenticationHelperProtocol <NSObject>

- (void)authenticationHelperPassCodeVerified:(AuthenticationHelper*)authenticationHelper;
-(void)passCodeAuthenticationFailed;
-(void)qrAuthenticationFailed;
-(void)authenticationWasSuccessfull:(AuthenticationHelper *)authenticationHelper;
-(void)authenticationFailed:(AuthenticationHelper *)authenticationHelper;

@end

@interface AuthenticationHelper : NSObject <JsonHttpServiceProtocol, ScanCodeHelperProtocol>
{
}

@property (nonatomic, retain) JsonHttpService *httpService;
@property (nonatomic, retain) id <AuthenticationHelperProtocol> delegate;

- (void)authenticateUser;

@end
