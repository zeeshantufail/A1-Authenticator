//
//  JsonHttpService.m
//  iGreeting
//
//  Created by svp on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JsonHttpService.h"
#import "JSON.h"
#import "Reachability.h"
#import "AppSettings.h"
#import "SVProgressHUD.h"
#import "AppHelper.h"

//#import "ProgressView.h"
//#import "iGreetingDAO.h"

@interface JsonHttpService()
- (BOOL)fetchServerUrl;
- (void)showRetryConfirmation;
@end


@implementation JsonHttpService
@synthesize delegate;

#define ALERT_VIEW_IP_SERVER_RETRY_TAG		700;


@synthesize responseData,tempConnection;
@synthesize progressView;
@synthesize retryConnection = retryConnection;
@synthesize showProgressHud = showProgressHud;
@synthesize requestUrl;//, delegate;
@synthesize request;

JsonHttpService *serviceRef;
BOOL isSecure;

static NSString *HostUrl;
static NSString *HostUrlSecure;

+ (void)setServerUrl:(NSString *)hostUrl secureUrl:(NSString *) secureHostUrl {
    HostUrl = HOST_URL;
    HostUrlSecure = HOST_URL_SECURE;
}

-(BOOL)checkForNetworkConnection{
	return YES;
}

-(BOOL)checkForNetworkConnectionAndReturn {
	
	BOOL status = NO;
	
	Reachability *checkForInternetConnection = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [checkForInternetConnection currentReachabilityStatus];
	
	Reachability *checkForHost = nil;
	if (HostUrl) {
		checkForHost = [Reachability reachabilityWithHostName:@"www.google.com"];
	}else {
		checkForHost = [Reachability reachabilityWithHostName:@"www.google.com.pk"];
	}
	NetworkStatus hostStatus = [checkForHost currentReachabilityStatus];
	
	if (((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) || ((hostStatus != ReachableViaWiFi) && (hostStatus != ReachableViaWWAN))){
		status = NO;
	}
	else {
		status = YES;
	}
	
	return status;
	
}
 

- (id)initWithDelegate:(id <JsonHttpServiceProtocol>) delegateIn {
    
    if (self = [super init]) {
        self.delegate = delegateIn;
        self.retryConnection = YES;
    }
	return [self init];
}

#define ESCAPE_CHARS       @"!*'();:@&=+$,/?%#[]"

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)authenticateUser {
    NSString *url = [[AppSettings sharedAppSettings] applicationAuthenticationUrl];
    NSString *userName = [[AppSettings sharedAppSettings] appUserName];
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                  (CFStringRef)url,
                                                                  CFSTR(""),
                                                                  kCFStringEncodingUTF8);
    NSString *regID = [[AppSettings sharedAppSettings] appRegId];
    NSString *deviceID = [AppHelper deviceID];

    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username", regID, @"registrationid", deviceID, @"deviceid", nil];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String: %@", jsonStr);
    //NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:YES doRetryConnection:NO doUseSecureChannel:NO];
}

- (void)sendRequestEmailWithSubject:(NSString*)subject body:(NSString*)body {
    NSMutableString *emailUrl = [[[AppSettings sharedAppSettings] applicationAuthenticationUrl] mutableCopy];
    NSRange range = [emailUrl rangeOfString:@"%2Frest%2F"];
    range.location = range.location + range.length;
    range.length = emailUrl.length - range.location;
    [emailUrl replaceCharactersInRange:range withString:@"appl/webtop/wflow/sendemail"];
    
    NSString *url = emailUrl;
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef)url,
                                                                                       CFSTR(""),
                                                                                       kCFStringEncodingUTF8);
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:subject, @"subject", body, @"bodytext", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String : %@", jsonStr);
    //NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:YES doRetryConnection:NO doUseSecureChannel:NO];
}

- (void)sendFeedbackEmailWithSubject:(NSString*)subject body:(NSString*)body {
    NSMutableString *emailUrl = [[[AppSettings sharedAppSettings] applicationAuthenticationUrl] mutableCopy];
    NSRange range = [emailUrl rangeOfString:@"%2Frest%2F"];
    range.location = range.location + range.length;
    range.length = emailUrl.length - range.location;
    [emailUrl replaceCharactersInRange:range withString:@"appl/webtop/wflow/sendemail"];
    
    NSString *url = emailUrl;
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef)url,
                                                                                       CFSTR(""),
                                                                                       kCFStringEncodingUTF8);
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:subject, @"subject", body, @"bodytext", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String: %@", jsonStr);
    //NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:YES doRetryConnection:NO doUseSecureChannel:NO];
}

- (void)verifyPasscode:(NSString*)passcode {
//    NSString *url = [[AppSettings sharedAppSettings] applicationAuthenticationUrl];
//    NSString *userName = [[AppSettings sharedAppSettings] appUserName];
//    NSString *deviceName = [[AppSettings sharedAppSettings] getDeviceName];
//    NSString *deviceVersion = [[AppSettings sharedAppSettings] getDeviceVersion];
//    NSString *deviceId = [[AppSettings sharedAppSettings] getDeviceId];
//    NSString *deviceResolution = [[AppSettings sharedAppSettings] getDeviceResolution];
//    NSString *deviceColorDepth = [[AppSettings sharedAppSettings] getDeviceColorDepth];
//    NSString *deviceType = [[AppSettings sharedAppSettings] getDeviceType];
//    NSString *deviceOS = [[AppSettings sharedAppSettings] getDeviceOS];
//    NSString *deviceBrowser = [[AppSettings sharedAppSettings] getDeviceBrowser];
//    
//    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
//                                                                   (CFStringRef)url,
//                                                                   CFSTR(""),
//                                                                   kCFStringEncodingUTF8);
//    
//    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username", passcode, @"passcode", deviceName, @"devicename", deviceVersion, @"deviceversion", deviceId, @"deviceid", deviceResolution, @"deviceresolution", deviceColorDepth, @"devicecolordepth", deviceType, @"devicetype", deviceOS, @"deviceos", deviceBrowser, @"devicebrowser", nil];
    
    NSString *url = [[AppSettings sharedAppSettings] applicationAuthenticationUrl];
    NSString *userName = [[AppSettings sharedAppSettings] appUserName];
    NSString *deviceId = [AppHelper deviceID];
    NSString *challengeCode = [[AppSettings sharedAppSettings] qrChanllangeCode];
    NSString *registrationId = [[AppSettings sharedAppSettings] appRegId];
    
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef)url,
                                                                                       CFSTR(""),
                                                                                       kCFStringEncodingUTF8);
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username",registrationId, @"registrationid", passcode, @"passcode", deviceId, @"deviceid", challengeCode, @"qrchallengecode", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String secondCall: %@", jsonStr);
    //NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:NO doRetryConnection:NO doUseSecureChannel:NO];
}

- (void)updateNotificationToken {
    
    NSArray *links = [[AppSettings sharedAppSettings] appFinalLinks];
    NSLog(@"the links %@", links);
//    NSString *url = @"https://localhost:9443/Login/rest/appl/sainsburry/wflow/savedevicetoken";//[[AppSettings sharedAppSettings] applicationAuthenticationUrl];
    
    NSString *url = @"";
    
    for (NSDictionary *link in links) {
        if ([[link objectForKey:@"rel"] isEqualToString:@"devicetoken"]) {
            url = [link objectForKey:@"href"];
            break;
        }
    }
    
    NSString *userName = [[AppSettings sharedAppSettings] appUserName];
    NSString *token = [[AppSettings sharedAppSettings] appNotificationToken];
    
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef)url,
                                                                                       CFSTR(""),
                                                                                       kCFStringEncodingUTF8);
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username",token, @"devicetoken", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String secondCall: %@", jsonStr);
    //NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:NO doRetryConnection:NO doUseSecureChannel:NO];
}


- (void)fetchNotificationsRequest{
    
    NSArray * links = [[AppSettings sharedAppSettings] appFinalLinks];
    
    NSString *url = @"";
    
    for (NSDictionary *link in links) {
        if ([[link objectForKey:@"rel"] isEqualToString:@"getnotifications"]) {
            url = [link objectForKey:@"href"];
            break;
        }
    }
    
    
//    NSString *url = @"https://localhost:9443/Login/rest/appl/sainsburry/wflow/getnotification";//[[AppSettings sharedAppSettings] applicationAuthenticationUrl];
    NSString *userName = [[AppSettings sharedAppSettings] appUserName];
    NSString *token = [[AppSettings sharedAppSettings] appNotificationToken];
    
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef)url,
                                                                                       CFSTR(""),
                                                                                       kCFStringEncodingUTF8);
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username",token, @"devicetoken", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String secondCall: %@", jsonStr);
    //NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:NO doRetryConnection:NO doUseSecureChannel:NO];
}


- (void)requestFinalLink:(NSString *)url{
    
//    NSString *url = @"https://localhost:9443/Login/rest/appl/sainsburry/wflow/getnotification";//[[AppSettings sharedAppSettings] applicationAuthenticationUrl];
    NSString *userName = [[AppSettings sharedAppSettings] appUserName];
    
    NSString *str = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                       (CFStringRef)url,
                                                                                       CFSTR(""),
                                                                                       kCFStringEncodingUTF8);
    
    NSDictionary *arg = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"username", nil];
//
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:arg, @"attributes", nil];
    
    NSString *jsonStr = [dic JSONRepresentation];
    
    NSLog(@"String secondCall: %@", jsonStr);
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doRequest:str postdata:data doStartProgress:NO doRetryConnection:NO doUseSecureChannel:NO];
}

- (void)doRequest:(NSString *)rUrl postdata:(NSData*)postData doStartProgress:(BOOL)start doRetryConnection:(BOOL) retry doUseSecureChannel:(BOOL) secure
{
	self.retryConnection = retry;
	self.showProgressHud = start;
	isSecure = secure;
	self.requestUrl = rUrl;
	[requestUrl retain];

	if(start) {
		//[progressView show];
        [SVProgressHUD showWithStatus:@"Please wait..."];
	}

	if (![self checkForNetworkConnectionAndReturn]) {
		//[progressView dismiss];
        [SVProgressHUD dismiss];
		errorOccurred = YES;
		[self showRetryConfirmation];
		return;
	} else {
		errorOccurred = NO;
		NSString *url = rUrl;
	
		/*if(secure){
			url = [NSString stringWithFormat:@"%@%@",HostUrlSecure, rUrl];
		}else {
			url = [NSString stringWithFormat:@"%@%@",HostUrl, rUrl];
		}*/
	
		NSLog(@"Requesting at URL: %@", url);
		
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
		self.responseData = [[NSMutableData alloc] initWithCapacity:2];
        if (!self.request) {
            self.request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] autorelease];
        }
        else{
            self.request.URL = [NSURL URLWithString:url];
        }
        

        NSString *jwtToken = [[AppSettings sharedAppSettings] appJWTToken];
        if (postData) {
            [self.request setHTTPMethod:@"POST"];
            [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
            [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self.request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [self.request setValue:[self getUserAgentString] forHTTPHeaderField:@"User-Agent"];
            if (jwtToken) {
                [self.request setValue:[NSString stringWithFormat:@"Bearer %@", jwtToken] forHTTPHeaderField:@"Authorization"];
            }
            [self.request setHTTPBody:postData];
        }
		self.tempConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
		
	}

}


-(NSString *)getUserAgentString{
    NSString *product = @"A1RMA";
    NSString *platform = @"iOS";
    NSString *device = [[UIDevice currentDevice] model];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //NSString *subVersion = [version substringWithRange:NSMakeRange(2, 1)];
    //version =[version substringWithRange:NSMakeRange(0, 1)];
    NSString *userAgent = [[NSString alloc] initWithFormat:@"%@.%@.%@.%@",product, platform, device, version];
    NSLog(@"user agent = %@", userAgent);
    return userAgent;
}

- (void)showRetryConfirmation{
	NSString *cancelButtonTitle = @"Cancel";
	NSString *otherButtonTitle = @"Retry";
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: @"No Internet Connection"
							   message: @"Could not connect to server. You must have access to internet to use this application."
							   delegate:[self retain]
							   cancelButtonTitle:cancelButtonTitle
							   otherButtonTitles:otherButtonTitle, nil];
	
	[errorAlert show];
	[errorAlert release];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
	
	if ([challenge previousFailureCount] < 3) {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:HOST_USERNAME password:HOST_PASSWORD persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
	}else {
		/*UIAlertView *credentialFailure = [[UIAlertView alloc] initWithTitle:nil message:@"Failed to authenticate the application credentials with server." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[credentialFailure show];
		[credentialFailure release];*/
		[[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
		[self connection:connection didFailWithError:[NSError errorWithDomain:@"Credential validation failure" code:403 userInfo:nil]];
	}

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
//    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
//    cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    for (NSHTTPCookie *cookie in cookies) {
//        NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value);
//    }
    [responseData setLength:0];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Connection didFailWithError");
	
	//[progressView dismiss];
    [SVProgressHUD dismiss];
	errorOccurred = YES;
	NSString *cancelButtonTitle = @"Cancel";
	NSString *otherButtonTitle = @"Retry";
    if ([self.delegate respondsToSelector:@selector(jsonHttpServiceRequestFailed:)]) {
        [self.delegate jsonHttpServiceRequestFailed:self];
    }
    
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: @"Could not connect to server. You must have access to internet to use this application."
							   delegate:[self retain]
							   cancelButtonTitle:cancelButtonTitle
							   otherButtonTitles:otherButtonTitle, nil];
	
	[errorAlert show];
	[errorAlert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
        
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    for (NSHTTPCookie *cookie in cookies) {
//        NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value);
//    }
	
	if(!errorOccurred) {
		NSMutableDictionary *response = [responseString JSONValue] ;
		NSLog(@"response completed for: %@", responseString);
        
        NSString *linksStr = [response objectForKey:@"links"];
        
        if (linksStr) {
            NSArray * links = [linksStr JSONValue];
            [response setObject:links forKey:@"links"];
            NSLog(@"decoded response is: %@", [response JSONRepresentation]);
        }
        
        
		[responseString release];
        
        [SVProgressHUD dismiss];
		//if (response != nil) {
			//[progressView dismiss];
            //[controller responseCompleted:response];
            
            if ([self.delegate respondsToSelector:@selector(jsonHttpService:responseCompleted:)]) {
                [self.delegate jsonHttpService:self responseCompleted:response];
            }
             
            
			//[controller responseCompleted: response];
		//}

	}
}

- (void)dealloc {
    [SVProgressHUD dismiss];
    
    [request release];
	[progressView release];
	[tempConnection release];
	[requestUrl release];
	//[responseData release];
	[super dealloc];
}

@end
