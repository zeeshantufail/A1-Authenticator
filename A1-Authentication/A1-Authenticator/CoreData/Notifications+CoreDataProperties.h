//
//  Notifications+CoreDataProperties.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 26/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Notifications.h"

NS_ASSUME_NONNULL_BEGIN

@interface Notifications (CoreDataProperties)

@property BOOL read;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *data;

@end

NS_ASSUME_NONNULL_END
