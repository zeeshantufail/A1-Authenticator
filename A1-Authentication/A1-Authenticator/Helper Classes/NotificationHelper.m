//
//  NotificationHelper.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 30/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "NotificationHelper.h"
#import "A1HTTPService.h"
#import "AppDelegate.h"
#import "Notifications.h"

@implementation NotificationHelper

-(void)updateNotificationToken{
//    if(!self.httpService)
    self.httpService = [[A1HTTPService alloc] initWithDelegate:self];
    self.httpService.requestType = @"updateDeviceToken";
    
    [self.httpService updateNotificationToken];
}

-(void)fetchNotificationRequest{
//    if(!self.httpService)
    self.httpService = [[A1HTTPService alloc] initWithDelegate:self];
    self.httpService.requestType = @"getNotifications";
    [self.httpService fetchNotificationsRequest];
}

- (void)jsonHttpService:(JsonHttpService*)jsonHttpService responseCompleted:(NSMutableDictionary*)response{
    if ([jsonHttpService.requestType isEqualToString:@"getNotifications"]) {
        NSLog(@"getnotifications : %@", response);
        NSArray *messages = [response objectForKey:@"messages"];
        
        if (messages && [messages isKindOfClass:[NSArray class]] && messages.count > 0) {
            for (NSDictionary *notification in messages) {
                [Notifications saveNotification:notification];
            }
        }
        else if([messages isKindOfClass:[NSDictionary class]]){
            
            [Notifications saveNotification:(NSDictionary *)messages];
        }
        
        
        
    }
    else if([jsonHttpService.requestType isEqualToString:@"updateDeviceToken"])
    {
        
        NSLog(@"updateDeviceToken : %@", response);
        if ([[response objectForKey:@"status"] isEqualToString:@"success"]) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [appDelegate updateNotificationDB];
        }
        
    }
}
- (void)jsonHttpServiceRequestFailed:(JsonHttpService*)jsonHttpService{
    
}

@end
