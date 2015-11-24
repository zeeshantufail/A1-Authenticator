//
//  HistoryViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/10/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "HistoryViewController.h"
#import "SWRevealViewController.h"
#import "HistoryCustomCell.h"
#import "AppHelper.h"

@interface HistoryViewController ()
{
    NSMutableArray *historyArray;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    historyArray = [[NSMutableArray alloc] init];
    historyArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AuditHistory"] mutableCopy];
    
    [self addTapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addTapGesture
{
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    
    [self.view addGestureRecognizer:tap];
}

#pragma - mark table datasource and delagte

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AppHelper isIphone6p])
    {
        return 47.0f;
    }
    if ([AppHelper isIphone6])
    {
        return 44.0f;
    }
    return 39.0f;
}



//clear history to do


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";
    HistoryCustomCell *cell = (HistoryCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HistoryCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [historyArray objectAtIndex:indexPath.row];
    
    cell.dateTime.text = [dict objectForKey:@"datetime"];
    cell.performedAction.text = [dict objectForKey:@"action"];
    
    cell.image_View.layer.cornerRadius  = 14   ;
    cell.image_View.layer.masksToBounds = YES  ;
    
    if ([AppHelper isIphone6])
    {
        cell.image_View.layer.cornerRadius  = 15   ;
    }
    if ([AppHelper isIphone6p])
    {
        cell.image_View.layer.cornerRadius  = 18   ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)settingsBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

- (IBAction)clearHistoryBtnPressed:(id)sender
{
    if ([historyArray count] > 0)
    {
        [historyArray removeAllObjects];

        [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:@"AuditHistory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
    }
}

@end
