//
//  Notifications.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 26/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Notifications : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(void)saveNotification:(NSDictionary *)notification;
+(NSArray *)readNotifications;

@end

NS_ASSUME_NONNULL_END

#import "Notifications+CoreDataProperties.h"
