//
//  AppDelegate.h
//  A1-Authenticator
//
//  Created by Waqar on 11/2/15.
//  Copyright (c) 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NotificationHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NotificationHelperProtocol>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)registerForNotification;
-(void)updateNotificationDB;

@end

