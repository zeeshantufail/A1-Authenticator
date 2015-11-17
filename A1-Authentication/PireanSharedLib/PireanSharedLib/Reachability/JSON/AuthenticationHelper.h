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

@end

@interface AuthenticationHelper : NSObject <JsonHttpServiceProtocol, ScanCodeHelperProtocol>
{
    JsonHttpService *httpService;
    id <AuthenticationHelperProtocol> delegate;
}

@property (nonatomic, retain) JsonHttpService *httpService;
@property (nonatomic, assign) id <AuthenticationHelperProtocol> delegate;

- (void)authenticateUser;

@end
