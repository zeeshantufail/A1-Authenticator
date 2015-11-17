//
//  AppInfo.m
//  Mobile IAM
//
//  Created by khurram on 02/09/2013.
//  Copyright (c) 2013 Intagleo Systems. All rights reserved.
//

#define TAB_OPENED @"Tab opened"
#define TAB_CLOSED @"Tab closed"
#define APP_OPENED @"Application launched"
#define APP_CLOSED @"Application closed"

#import "AppInfo.h"

@implementation AppInfo

@dynamic operation;
@dynamic details;
@dynamic timeStamp;

+ (void)insertObjectIsAppStart:(BOOL)isAppStart withMOC:(NSManagedObjectContext*)moc
{
    AppInfo *appInfo = [NSEntityDescription insertNewObjectForEntityForName:@"AppInfo" inManagedObjectContext:moc];
    appInfo.operation = isAppStart ? APP_OPENED : APP_CLOSED;
    appInfo.details = @"Access: One";
    appInfo.timeStamp = [NSDate date];
    
    [moc save:nil];
    
}

+ (void)insertObjectIsTabOpened:(BOOL)isTabOpened tabName:(NSString*)tabName requestId:(NSInteger)requestIdIn withMOC:(NSManagedObjectContext*)moc
{
    AppInfo *appInfo = [NSEntityDescription insertNewObjectForEntityForName:@"AppInfo" inManagedObjectContext:moc];
    appInfo.operation = [NSString stringWithFormat:@"%@", isTabOpened ? TAB_OPENED : TAB_CLOSED];
    appInfo.details = tabName;
    appInfo.timeStamp = [NSDate date];
    
    [moc save:nil];
}

+ (NSArray*)getAllAppInfoObjectsWithMOC:(NSManagedObjectContext*)moc {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AppInfo" inManagedObjectContext:moc];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	
	NSError *error;
	NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

+ (void)deleteAllObjects:(NSManagedObjectContext *)moc{
    
  /*  NSFetchRequest * fetch = [[[NSFetchRequest alloc] init] autorelease];
    [fetch setEntity:[NSEntityDescription entityForName:@"AppInfo" inManagedObjectContext:moc]];
    NSArray * result = [moc executeFetchRequest:fetch error:nil];
    for (id info1 in result)
        [moc deleteObject:info1];
    
    NSError *tmpErro;
    [moc save:&tmpErro];*/
}

@end
