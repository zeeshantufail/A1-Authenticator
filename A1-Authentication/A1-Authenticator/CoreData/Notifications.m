//
//  Notifications.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 26/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "Notifications.h"
#import "AppDelegate.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

@implementation Notifications

// Insert code here to add functionality to your managed object subclass

+(void)saveNotification:(NSDictionary *)notification{
    
    //testing
//    notification = [[NSDictionary alloc] initWithObjectsAndKeys:@"title",@"test notification", nil];

    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Notifications *not = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Notifications"
                                      inManagedObjectContext:context];
    
    
    not.data = [notification JSONRepresentation];
    
//    str jsonValue; for readback
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
   
}


+(NSArray *)readNotifications{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notifications"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (Notifications *not in fetchedObjects) {
        NSLog(@"Notification data: %@", not.data);
        
    }
    return  fetchedObjects;
}
@end
