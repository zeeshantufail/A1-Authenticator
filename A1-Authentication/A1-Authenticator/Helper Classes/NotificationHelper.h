//
//  NotificationHelper.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 30/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonHttpService.h"
#import "ScanCodeHelper.h"

@class AuthenticationHelper;

@protocol NotificationHelperProtocol <NSObject>

-(void)notificationReceived:(NSArray *)notifications;
-(void)notificationAppTokenUpdated;
-(void)notificationRequestFailed:(NSString *)error;

@end

@interface NotificationHelper : NSObject <JsonHttpServiceProtocol>
{
}

@property (nonatomic, retain) JsonHttpService *httpService;
@property (nonatomic, assign) id <NotificationHelperProtocol> delegate;

-(void)updateNotificationToken;
-(void)fetchNotificationRequest;

@end
