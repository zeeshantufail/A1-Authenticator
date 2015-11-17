//
//  SSPHTTPService.m
//  SelfServicePortal
//
//  Created by Zeeshan Tufail on 23/04/2015.
//
//

#import "A1HTTPService.h"
#import "AppSettings.h"

@implementation A1HTTPService

BOOL isSecure;


- (void)doRequest:(NSString *)rUrl postdata:(NSData*)postData doStartProgress:(BOOL)start doRetryConnection:(BOOL) retry doUseSecureChannel:(BOOL) secure
{
    self.retryConnection = retry;
    self.showProgressHud = start;
    isSecure = secure;
    self.requestUrl = rUrl;
    [self.requestUrl retain];
    
    if(start) {
        [self.progressView show];
        [SVProgressHUD showWithStatus:@"Please wait..."];
    }
    
    if (![self checkForNetworkConnectionAndReturn]) {
        [self.progressView dismiss];
        [AppHelper connectionFailedNotification];
        [SVProgressHUD dismiss];
        errorOccurred = YES;
        //[self showRetryConfirmation];
        return;
    } else {
        errorOccurred = NO;
        NSString *url = rUrl;
        
        NSLog(@"Requesting at URL: %@", url);
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        self.responseData = [[NSMutableData alloc] initWithCapacity:2];
        if (!self.request) {
            self.request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] autorelease];
        }
        
        if (postData) {
            [self.request setHTTPMethod:@"POST"];
            [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
            [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [self.request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [self.request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [self.request setValue:[self getUserAgentString] forHTTPHeaderField:@"User-Agent"];
            [self.request setHTTPBody:postData];
            
            NSLog(@"%@", [self.request valueForHTTPHeaderField:@"User-Agent"]);
        }
        NSLog(@"%@", self.request);
        self.tempConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        
    }
    
}


-(NSString *)getUserAgentString{
    NSString *product = @"A1AUTH";//todo zeeshan
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
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showRetryConfirmation) object:nil];
    
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
    errorAlert = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection didFailWithError");
    [AppHelper connectionFailedNotification];
    [SVProgressHUD dismiss];
    errorOccurred = YES;
    NSString *cancelButtonTitle = @"Cancel";
    NSString *otherButtonTitle = @"Retry";
    
    NSLog(@"%@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: @"Could not connect to server. You must have access to internet to use this application."
                               delegate:[self retain]
                               cancelButtonTitle:cancelButtonTitle
                               otherButtonTitles:otherButtonTitle, nil];
        [errorAlert show];
    [errorAlert release];
    errorAlert = nil;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    UIViewController *currentController;
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
//            currentController = [ScanTestAppDelegate topMostController];
//            if([currentController isKindOfClass:[MainWebViewController class]])
//            {
//                MainWebViewController *webController = (MainWebViewController*)currentController;
//                [webController authenticateUser];
//            }
            
            //todo zeeshan
            break;
            
        default:
            break;
    }
}



@end
