//
//  JsonHttpService.h
//  iGreeting
//
//  Created by svp on 12/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "CommonUtility.h"


#define IP_FILE_URL		@"http://intagleo.co.uk/uGotGiftServer.txt"

//#define HOST_URL		@"http://igreetingsdev.appspot.com"
//#define HOST_URL_SECURE @"https://igreetingsdev.appspot.com"

#define HOST_URL        @"http://igreetingcheck.appspot.com"
#define HOST_URL_SECURE @"https://igreetingcheck.appspot.com"

//#define HOST_URL        @"http://igreetingsapp.appspot.com/"
//#define HOST_URL_SECURE @"https://igreetingsapp.appspot.com/"

//#define HOST_URL        @"http://igreetings123.appspot.com/"
//#define HOST_URL_SECURE @"https://igreetings123.appspot.com/"

#define HOST_USERNAME @"uGotGiftApp"
#define HOST_PASSWORD @"egleo@apple"


@class ProgressView, JsonHttpService;


@protocol  JsonHttpServiceProtocol <NSObject>

- (void)jsonHttpService:(JsonHttpService*)jsonHttpService responseCompleted:(NSMutableDictionary*)response;
- (void)jsonHttpServiceRequestFailed:(JsonHttpService*)jsonHttpService;

@end


@interface JsonHttpService : NSObject <UIAlertViewDelegate> {
	NSMutableData *responseData;
	ProgressView *progressView; 
    id <JsonHttpServiceProtocol> delegate;
	id controller;
	NSString *requestUrl;
	
	BOOL errorOccurred;
	BOOL retryConnection;
	BOOL showProgressHud;
	NSURLConnection *tempConnection;
    NSMutableURLRequest *request;
//	Reachability* hostReach;
}

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSString *requestUrl;
@property (nonatomic, retain) IBOutlet ProgressView *progressView;
@property (nonatomic, getter = doRetryConnection) BOOL retryConnection;
@property (nonatomic, getter = doShowProgressHud) BOOL showProgressHud;
@property (nonatomic, retain) NSURLConnection *tempConnection;
@property (nonatomic, retain) NSMutableURLRequest *request;

@property (nonatomic, retain) NSString * requestType;

@property (nonatomic, retain) id <JsonHttpServiceProtocol> delegate;

- (id)initWithDelegate:(id <JsonHttpServiceProtocol>) delegateIn;

- (BOOL)checkForNetworkConnection;
- (void)doRequest:(NSString *)rUrl postdata:(NSData*)postData doStartProgress:(BOOL)start doRetryConnection:(BOOL) retry doUseSecureChannel:(BOOL) secure;
- (BOOL)checkForNetworkConnectionAndReturn;
- (void)authenticateUser;
- (void)verifyPasscode:(NSString*)passcode;
- (void)sendFeedbackEmailWithSubject:(NSString*)subject body:(NSString*)body;
- (void)sendRequestEmailWithSubject:(NSString*)subject body:(NSString*)body;

+ (void)setServerUrl:(NSString *)hostUrl secureUrl:(NSString *) secureHostUrl;

- (void)updateNotificationToken ;
- (void)fetchNotificationsRequest;
- (void)requestFinalLink:(NSString *)url;

@end
