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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Notifications *not = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"Notifications"
                                      inManagedObjectContext:context];
    
    
    not.data = [notification JSONRepresentation];
    not.read = false;
//    str jsonValue; for readback
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
   
}


+(NSMutableArray *)readNotifications{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notifications"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for (Notifications *not in fetchedObjects) {
        NSLog(@"Notification data: %@", not.data);
        if (not.data) {
            [ary addObject:[not.data JSONValue]];
        }
        
    }
    return  ary;
}

+(int)numberOfUnreadNotifications{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notifications"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    int count = 0;
    for (Notifications *not in fetchedObjects) {
        NSDictionary *dict = [not.data JSONValue];
        bool isread = [[dict objectForKey:@"readMessage"] intValue];
        
        if (!isread) {
            count++;
        }
        
    }
    return  count;
}
@end
