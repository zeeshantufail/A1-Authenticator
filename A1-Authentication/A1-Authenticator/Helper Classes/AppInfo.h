//
//  AppInfo.h
//  Mobile IAM
//
//  Created by khurram on 02/09/2013.
//  Copyright (c) 2013 Intagleo Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AppInfo : NSManagedObject

@property (nonatomic, retain) NSString * operation;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * timeStamp;

+ (void)insertObjectIsTabOpened:(BOOL)isTabOpened tabName:(NSString*)tabName requestId:(NSInteger)requestIdIn withMOC:(NSManagedObjectContext*)moc;
+ (void)insertObjectIsAppStart:(BOOL)isAppStart withMOC:(NSManagedObjectContext*)moc;
+ (NSArray*)getAllAppInfoObjectsWithMOC:(NSManagedObjectContext*)moc;
+ (void)deleteAllObjects:(NSManagedObjectContext *)moc;
@end
