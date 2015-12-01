    //
//  AuthenticationHelper.m
//  RMAWebTop
//
//  Created by khurram on 04/06/2013.
//  Copyright (c) 2013 Intagleo Systems. All rights reserved.
//

#import "AuthenticationHelper.h"
#import "AppSettings.h"

@implementation AuthenticationHelper
@synthesize httpService, delegate;

- (void)authenticateUser {
    self.httpService = [[JsonHttpService alloc] initWithDelegate:self];
    [self.httpService authenticateUser];
}

- (void)scanCodeHelper:(ScanCodeHelper *)scanCodeHelper passCode:(NSString *)passCode {
    //NSLog(@"Passcode: %@", passCode);
    //self.httpService = [[JsonHttpService alloc] initWithDelegate:self];
    [self.httpService verifyPasscode:passCode];
}

- (void)generatePasscodeWithChallangeCode:(NSString*)challanegCode {
    [[AppSettings sharedAppSettings] setQRChanllangeCode:challanegCode];
    ScanCodeHelper *scanCodeHelper = [[[ScanCodeHelper alloc] init] autorelease];
    scanCodeHelper.delegate = self;
    [scanCodeHelper generatePasscodeWithChallangeString:[[AppSettings sharedAppSettings] qrChanllangeCode] challanegLength:6];
}

- (void)jsonHttpServiceRequestFailed:(JsonHttpService *)jsonHttpService {
    
}

- (void)jsonHttpService:(JsonHttpService *)jsonHttpService responseCompleted:(NSMutableDictionary *)response {
    NSLog(@"json response completed");
    NSString *challangeCode = [response objectForKey:@"qrchallengecode"];
    
//    if ([challangeCode isKindOfClass:[NSArray class]]) { //todo zeeshan
//        NSArray *code = (NSArray *)challangeCode;
//        challangeCode = [code objectAtIndex:0];
//    }
    
    NSLog(@"ChallangeCode: %@", challangeCode);
    
    NSString *initialUrl = [response objectForKey:@"initialurl"];
    NSLog(@"initialUrl = %@",initialUrl);
    
    NSArray *links = [response objectForKey:@"links"];
    NSString *jwtToken = [response objectForKey:@"token"];
    
    NSString *secretKey = [response objectForKey:@"secretkey"];
    NSString *userEmail = [response objectForKey:@"useremail"];
    
    NSString * designation = [response objectForKey:@"designation"];
    NSString * company = [response objectForKey:@"company"];
    
    NSString * userFirstName = [response objectForKey:@"firstname"];
    NSString *userLastName = [response objectForKey:@"surname"];
    
    if (userFirstName.length > 0 && userLastName.length > 0) {
        [[AppSettings sharedAppSettings] setAppUserFirstName:userFirstName];
        [[AppSettings sharedAppSettings] setAppUserLastName:userLastName];
        NSLog(@"user name and password is set from authentication helper");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
    }
    
    if (challangeCode) {
        [self generatePasscodeWithChallangeCode:challangeCode];
    }
    else if (initialUrl) {
        
        NSString *qrResponseCode = [response objectForKey:@"qrresponsecode"];
        if ([qrResponseCode isEqualToString:@"0000"])
        {
            
            NSString *a1SessionCookie = [response objectForKey:@"a1_session_cookie"];
            
            [[AppSettings sharedAppSettings] setA1SessionCookie:a1SessionCookie];
            [[AppSettings sharedAppSettings] setWebtopInitialUrl:initialUrl];
            
            if ([self.delegate respondsToSelector:@selector(authenticationHelperPassCodeVerified:)]) {
                [self.delegate authenticationHelperPassCodeVerified:self];
            }
        }
        else {
            [[[[UIAlertView alloc] initWithTitle:@"" message:@"Passcode authentication Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease] show];
        }
    }
    else if( links && jwtToken){
        
        [[AppSettings sharedAppSettings] setAppJWTToken:jwtToken];
        [[AppSettings sharedAppSettings] setAppFinalLinks:links];
        for (NSDictionary * link in links) {
            NSString *rel = [link objectForKey:@"rel"];
            NSString *href = [link objectForKey:@"href"];
            
            if ([rel isEqualToString:@"googleauth"] && href) {
                [self.httpService requestFinalLink:href];
            }
            else if ( [rel isEqualToString:@"getuserdetails"] && href ) {
                [self.httpService requestFinalLink:href];
            }
        }
    }
    else if(secretKey){
        [[AppSettings sharedAppSettings] setGoogleSecret:secretKey];
        
        if ([[AppSettings sharedAppSettings] appUserEmail]) {
            [self.delegate authenticationWasSuccessfull:self];
        }
    }
    else if(userEmail){
        [[AppSettings sharedAppSettings] setAppUserEmail:userEmail];
        [[AppSettings sharedAppSettings] setAppUserFirstName:userFirstName];
        [[AppSettings sharedAppSettings] setAppUserLastName:userLastName];
        [[AppSettings sharedAppSettings] setAppUserDesignation:designation];
        [[AppSettings sharedAppSettings] setAppRegName:company];
        
        if ([[AppSettings sharedAppSettings] googleSecret]) {
            [self.delegate authenticationWasSuccessfull:self];
        }
//        [AppSettings sharedAppSettings] 
    }
    else {
        [[[[UIAlertView alloc] initWithTitle:@"" message:@"Authentication Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] autorelease] show];
    }
}



-(void)dealloc{
    //[super dealloc];
    [self.httpService.delegate release];
    self.httpService.delegate = nil;
}

@end
