//
//  NotificationViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/6/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCustomCell.h"
#import "SWRevealViewController.h"
#import "MGSwipeButton.h"
#import "AppHelper.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "Notifications.h"

@interface NotificationViewController ()
{
    NSInteger previousSelectedIndexRowPath;
    NSInteger selectedIndexRowPath;
    NSMutableArray *notificationsArray;
    NSMutableArray *notificationsDataViews;
    NSMutableArray *selectedRowsArray;
    BOOL showMarkAsRead;
}

@end

@implementation NotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
    
//    NSString *str1 = @"{\"status\":\"success\",\"messages\":{\"badge\":1,\"readMessage\":false,\"date\":\"2015/12/01 00:32:12\",\"header\":\"Access: One OTP\",\"title\":\"Your otp passcode is updated\",\"message\":\"Welcome to A1 Authenticator application. Your OPT is ION280tho! ---- Welcome to A1 Authenticator application. Your OPT is ION280tho! ---- Welcome to A1 Authenticator application. Your OPT is ION280tho!\"}}";
//    NSString *str2 = @"{\"status\":\"success\",\"messages\":{\"badge\":1,\"readMessage\":true,\"date\":\"2015/12/01 00:32:12\",\"header\":\"Access: One OTP\",\"title\":\"Your otp passcode is updated\",\"message\":\"Welcome to A1 Authenticator application. Your OPT is ION280tho!\"}}";
//    NSString *str3 = @"{\"status\":\"success\",\"messages\":{\"badge\":1,\"readMessage\":false,\"date\":\"2015/12/01 00:32:12\",\"header\":\"Access: One OTP\",\"title\":\"Your otp passcode is updated\",\"message\":\"Welcome to A1 Authenticator application. Your OPT is ION280tho!\"}}";
//    NSString *str4 = @"{\"status\":\"success\",\"messages\":{\"badge\":1,\"readMessage\":true,\"date\":\"2015/12/01 00:32:12\",\"header\":\"Access: One OTP\",\"title\":\"Your otp passcode is updated\",\"message\":\"Welcome to A1 Authenticator application. Your OPT is ION280tho!\"}}";
//    NSString *str5 = @"{\"status\":\"success\",\"messages\":{\"badge\":1,\"readMessage\":false,\"date\":\"2015/12/01 00:32:12\",\"header\":\"Access: One OTP\",\"title\":\"Your otp passcode is updated\",\"message\":\"Welcome to A1 Authenticator application. Your OPT is ION280tho!\"}}";
//    NSString *str6 = @"{\"status\":\"success\",\"messages\":{\"badge\":1,\"readMessage\":true,\"date\":\"2015/12/01 00:32:12\",\"header\":\"Access: One OTP\",\"title\":\"Your otp passcode is updated\",\"message\":\"Welcome to A1 Authenticator application. Your OPT is ION280tho!\"}}";
//    
//    NSDictionary *dic1 = [[NSDictionary alloc] initWithDictionary:[str1 JSONValue] copyItems:YES];
//    NSDictionary *dic2 = [[NSDictionary alloc] initWithDictionary:[str2 JSONValue] copyItems:YES];
//    NSDictionary *dic3 = [[NSDictionary alloc] initWithDictionary:[str3 JSONValue] copyItems:YES];
//    NSDictionary *dic4 = [[NSDictionary alloc] initWithDictionary:[str4 JSONValue] copyItems:YES];
//    NSDictionary *dic5 = [[NSDictionary alloc] initWithDictionary:[str5 JSONValue] copyItems:YES];
//    NSDictionary *dic6 = [[NSDictionary alloc] initWithDictionary:[str6 JSONValue] copyItems:YES];
//    
//    [notificationsArray addObject:dic1];
//    [notificationsArray addObject:dic2];
//    [notificationsArray addObject:dic3];
//    [notificationsArray addObject:dic4];
//    [notificationsArray addObject:dic5];
//    [notificationsArray addObject:dic6];
    
    notificationsArray = [Notifications readNotifications];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initialization
{
    notificationsDataViews = [[NSMutableArray alloc] init];
    notificationsArray = [[NSMutableArray alloc] init];
    selectedRowsArray  = [[NSMutableArray alloc] init];
    
//    NSDictionary *dictTemp = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              @"line 1",@"line1",
//                              @"line 2",@"line2",
//                              @"line 3",@"line3",
//                              @"line 4",@"line4",
//                              nil];
//    
//    
//    for (int i = 0; i < 5; i++) {
//        [notificationsArray addObject:dictTemp];
//    }
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.popOverView setHidden:YES];
    [self.popOverView setAlpha:0];
    
    [self.backBtn setHidden:YES];
    
    selectedIndexRowPath = -1;
    previousSelectedIndexRowPath = -1;
}

#pragma - mark table datasource and delagte

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == selectedIndexRowPath)
    {
        //[self setHeight:indexPath];

        UIView *v = [notificationsDataViews objectAtIndex:indexPath.row];
       
        return v.frame.size.height+60;
    }
    else
    {
        //[self setHeight:indexPath];
        
        return 60.0;
    }
    
}

-(void)setHeight:(NSIndexPath *)indexPath
{
    NotificationCustomCell *cell = (NotificationCustomCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row == selectedIndexRowPath)
    {
        NSString *dayLabel = cell.dayLabel.text;
        cell.dayLabel.text = cell.subtitle2.text;
        cell.subtitle2.text = dayLabel;
        [cell.dayLabel setHidden:YES];
    }
    else
    {
        NSString *dayLabel = cell.subtitle2.text;
        cell.subtitle2.text = cell.dayLabel.text;
        cell.dayLabel.text = dayLabel;
        [cell.dayLabel setHidden:NO];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"notificationCell";
    NotificationCustomCell *cell = (NotificationCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[NotificationCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    
    [cell.selectionBtn addTarget:self action:@selector(checkBoxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.selectionBtn setImage:[UIImage imageNamed:@"deselect.png"] forState:UIControlStateNormal];
    [cell.selectionBtn setTag:indexPath.row];
    
    cell.image_View.layer.cornerRadius  = 21   ;
    cell.image_View.layer.masksToBounds = YES  ;
    
    NSDictionary *dict = [notificationsArray objectAtIndex:indexPath.row];
    
    cell.dayLabel.text = [dict objectForKey:@"date"];
    cell.title.text = [dict objectForKey:@"header"];
    cell.subtitle1.text = [dict objectForKey:@"title"];
    cell.subtitle2.text = [dict objectForKey:@"message"];
    
    UIView *dataView = [self notificationDataForRowAtIndexPath:indexPath forCell:cell];
    [cell.cellMainView addSubview:dataView];
    
    BOOL read = [[dict objectForKey:@"readMessage"] integerValue];
    if (read)
    {
        cell.cellMainView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
        cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    }
    else
    {
        cell.cellMainView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame)-20, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
    [cell.contentView addSubview:separatorLineView];
    
    [self animateCell:cell atIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.popOverView.hidden == NO)
    {
        self.popOverView.hidden = YES;
    }
    
    //NotificationCustomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == selectedIndexRowPath)
    {
        selectedIndexRowPath = -1;
    }
    else
    {
        previousSelectedIndexRowPath = selectedIndexRowPath;
        selectedIndexRowPath = indexPath.row ;
        
        if (previousSelectedIndexRowPath != -1)
        {
            NSIndexPath *index_Path = [NSIndexPath indexPathForRow:previousSelectedIndexRowPath inSection:0];
            NotificationCustomCell *previousSelectedCell = [tableView cellForRowAtIndexPath:index_Path];
            NSString *previousCellDayLabel = previousSelectedCell.dayLabel.text;
            previousSelectedCell.dayLabel.text = previousSelectedCell.subtitle2.text;
            previousSelectedCell.subtitle2.text = previousCellDayLabel;
            [previousSelectedCell.dayLabel setHidden:NO];
        }
    }
    
    
//    if (indexPath.row == selectedIndexRowPath)
//    {
//        // last selected cell is now deselected
//        selectedIndexRowPath = -1;
//        
//        // exchange last selected cell's dayLabel text with subtitle2 text
//        NSString *dayLabel = cell.subtitle2.text;
//        cell.subtitle2.text = cell.dayLabel.text;
//        cell.dayLabel.text = dayLabel;
//
//        [cell.dayLabel setHidden:NO];
//    }
//    else
//    {
////        if (previousSelectedIndexRowPath >= 0)
////        {
//            // exchange previous selected cell's dayLabel text with subtitle2 text
//            NSIndexPath *index_Path = [NSIndexPath indexPathForRow:selectedIndexRowPath inSection:0];
//            NotificationCustomCell *previousSelectedCell = [tableView cellForRowAtIndexPath:index_Path];
//            NSString *previousCellDayLabel = previousSelectedCell.dayLabel.text;
//            previousSelectedCell.dayLabel.text = previousSelectedCell.subtitle2.text;
//            previousSelectedCell.subtitle2.text = previousCellDayLabel;
//            [previousSelectedCell.dayLabel setHidden:NO];
////            /////////////////////////////////////////////////////////////////////////
////        }
//        
//        previousSelectedIndexRowPath = selectedIndexRowPath;
//        // new cell is now selected without deselecting previous selected cell
//        selectedIndexRowPath = indexPath.row ;
//        
//        // exchange currently selected cell's dayLabel text with subtitle2 text
//        NSString *dayLabel = cell.dayLabel.text;
//        cell.dayLabel.text = cell.subtitle2.text;
//        cell.subtitle2.text = dayLabel;
//
//        [cell.dayLabel setHidden:YES];
//    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Mark as unread" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        // Respond to the action.
//        NSLog(@"swipe action");
//    }];
//    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        // Respond to the action.
//        NSLog(@"swipe action");
//    }];
//    
//    action1.backgroundColor = [UIColor blueColor];
//    action2.backgroundColor = [UIColor redColor];
//    return @[action1,action2];
//}

-(UIView *) notificationDataForRowAtIndexPath:(NSIndexPath *)indexPath forCell:(NotificationCustomCell *)cell
{
    float cellHeight = [self tableView:self.tableView heightForRowAtIndexPath: indexPath];
    
    UIView *notificationDataContainer = [[UIView alloc] init];
    
    UITextView *tv = [[UITextView alloc] init];
    
    [tv setUserInteractionEnabled:NO];
    tv.textColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
    tv.backgroundColor = [UIColor clearColor];
    
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width - 26, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0];
    [cell.cellMainView addSubview:separatorLineView];
    
    [notificationDataContainer addSubview:separatorLineView];
    
    tv.frame = CGRectMake(0, 10, self.tableView.frame.size.width-26,5);
    [tv setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    
    NSDictionary *notification_dict = [notificationsArray objectAtIndex:indexPath.row];
    tv.text = [notification_dict  objectForKey:@"message"];
    
    CGRect frame = tv.frame;
    frame.size.height = tv.contentSize.height;
    tv.frame = frame;
    
    float viewHeigt = tv.frame.size.height ;
    
    notificationDataContainer.frame = CGRectMake(50, cellHeight+5, CGRectGetWidth(self.tableView.frame)-20, 20+viewHeigt);
    
    cell.cellMainView.frame = CGRectMake(cell.cellMainView.frame.origin.x, 0, cell.cellMainView.frame.size.width, cellHeight + (20+viewHeigt));
    
    [notificationsDataViews addObject:notificationDataContainer];
    
    [notificationDataContainer addSubview:tv];

    return notificationDataContainer;
}

/*
-(UIView *) notificationDataForRowAtIndexPath:(NSIndexPath *)indexPath forCell:(NotificationCustomCell *)cell
{
    float cellHeight = [self tableView:self.tableView heightForRowAtIndexPath: indexPath];
    
    UIView *notificationDataContainer = [[UIView alloc] init];
    
    UILabel *l1 = [[UILabel alloc] init];
    UILabel *l2 = [[UILabel alloc] init];
    UILabel *l3 = [[UILabel alloc] init];
    UILabel *l4 = [[UILabel alloc] init];
    
    l3.numberOfLines = 2;
    l1.textColor = l2.textColor = l3.textColor = l4.textColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.0];
    l1.backgroundColor = l2.backgroundColor = l3.backgroundColor = l4.backgroundColor =[UIColor clearColor];
    
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width - 26, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    [cell.cellMainView addSubview:separatorLineView];
    
    [notificationDataContainer addSubview:separatorLineView];
    
    l1.frame = CGRectMake(0, 10, self.tableView.frame.size.width-26, 12);
    l2.frame = CGRectMake(0, 34, self.tableView.frame.size.width-26, 12);
    l3.frame = CGRectMake(0, 58, self.tableView.frame.size.width-26, 12);
    l4.frame = CGRectMake(0, 82, self.tableView.frame.size.width-26, 24);
    
    [l1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [l2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [l3 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [l4 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    
    NSDictionary *notification_dict = [notificationsArray objectAtIndex:indexPath.row];
    
    l1.text = [notification_dict objectForKey:@"line1"]; //@"Your OTP has been updated";
    l2.text = [notification_dict objectForKey:@"line2"]; //@"Your new code is 4556789";
    l3.text = [notification_dict objectForKey:@"line3"]; //@"This code was issued at 05:45:45 and will last for 60 seconds";
    l4.text = [notification_dict objectForKey:@"line4"]; //@"The Access One team";
    
    float viewHeigt = l1.frame.size.height + l2.frame.size.height + l3.frame.size.height + l4.frame.size.height ;
    
    notificationDataContainer.frame = CGRectMake(50, cellHeight+5, CGRectGetWidth(self.tableView.frame)-20, 2*viewHeigt);
    
    cell.cellMainView.frame = CGRectMake(cell.cellMainView.frame.origin.x, 0, cell.cellMainView.frame.size.width, cellHeight + (2*viewHeigt));
    
    [notificationsDataViews addObject:notificationDataContainer];
    
    [notificationDataContainer addSubview:l1];
    [notificationDataContainer addSubview:l2];
    [notificationDataContainer addSubview:l3];
    [notificationDataContainer addSubview:l4];
    
    return notificationDataContainer;
}
*/

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

int i = 2;

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    if (direction == MGSwipeDirectionLeftToRight)
    {
        //expansionSettings.fillOnTrigger = NO;
        //expansionSettings.threshold = 2;
    }
    else
    {
        expansionSettings.fillOnTrigger = YES;
        expansionSettings.threshold = 1.1;
        
        CGFloat padding = 8;
        
        MGSwipeButton * deleteBtn = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor colorWithRed:0.97 green:0.58 blue:0.11 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            [self deleteNotificationAtIndexPath:indexPath];
            
            return NO;
        }];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *dict = [notificationsArray objectAtIndex:indexPath.row];
        BOOL read = [[dict objectForKey:@"readMessage"] integerValue];
        
        if (read)
        {
            MGSwipeButton * unreadBtn = [MGSwipeButton buttonWithTitle:@"Mark as\nunread" backgroundColor:[UIColor colorWithRed:0.29 green:0.28 blue:0.28 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                
                NSIndexPath *index_Path = [self.tableView indexPathForCell:sender];
                NSDictionary *dict = [notificationsArray objectAtIndex:index_Path.row];
                dict[@"messages"][@"readMessage"] = @false;
                
                NotificationCustomCell *c = (NotificationCustomCell *)cell;
                c.cellMainView.backgroundColor = [UIColor whiteColor];
                c.backgroundColor = [UIColor whiteColor];
                
                [notificationsArray replaceObjectAtIndex:indexPath.row withObject:dict];
                
                [cell hideSwipeAnimated:YES];
                [cell refreshContentView];
                
                [self.tableView reloadData];

                return YES;
            }];
            
            return @[deleteBtn, unreadBtn];
        }
        else
        {
            MGSwipeButton * readBtn = [MGSwipeButton buttonWithTitle:@"Mark as\nread" backgroundColor:[UIColor colorWithRed:0.29 green:0.28 blue:0.28 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
                
                NSIndexPath *index_Path = [self.tableView indexPathForCell:sender];
                NSDictionary *dict = [notificationsArray objectAtIndex:index_Path.row];
                dict[@"messages"][@"readMessage"] = @true;
                
                NotificationCustomCell *c = (NotificationCustomCell *)cell;
                c.cellMainView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
                c.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
                
                [notificationsArray replaceObjectAtIndex:indexPath.row withObject:dict];
                
                [cell hideSwipeAnimated:YES];
                [cell refreshContentView];
                
                [self.tableView reloadData];
                
                return YES;
            }];
            
            return @[deleteBtn, readBtn];
        }
    }
    return nil;
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}


- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}


//- (CGFloat)buttonTotalWidth
//{
//    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.button2.frame);
//}


-(void)checkBoxBtnClick:(id)sender
{
    UIButton *checkBoxBtn = (UIButton*) sender;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath  = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if([self image:checkBoxBtn.imageView.image isEqualTo:[UIImage imageNamed:@"deselect.png"]])
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [selectedRowsArray addObject:indexPath];
    }
    else
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"deselect.png"] forState:UIControlStateNormal];
        
        if ([selectedRowsArray containsObject:indexPath])
        {
            [selectedRowsArray removeObject:indexPath];
        }
    }
    [self hidePopOverView];
}

-(void) animateCell:(NotificationCustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (editCells)
    {
        if (cell.cellMainView.frame.origin.x == -36)
        {
            [UIView animateWithDuration: 0.1 animations:^{
                cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x + 36, cell.cellMainView.center.y);
            }];
        }
        if (cell.cellMainView.frame.origin.x == -200)
        {
            [UIView animateWithDuration: 0.1 animations:^{
                cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x + 200, cell.cellMainView.center.y);
            }];
        }
    }
    if (goBackCells)
    {
        if (cell.cellMainView.frame.origin.x == 0)
        {
            [UIView animateWithDuration: 0.1 animations:^{
                cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x - 36, cell.cellMainView.center.y);
            }];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view != self.popOverView)
    {
        self.popOverView.hidden = YES;
    }
}

- (IBAction)settingsBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

- (IBAction)homeBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

bool editCells = false;

- (IBAction)editBtnPressed:(id)sender
{
    if ([self.editBtn.titleLabel.text isEqualToString:@"Action"] && [selectedRowsArray count] > 0)
    {
        if (![self isAtleastOneUnreadMessageSelected])
        {
            [self.markAsReadUnreadBtn setTitle:@"Mark As Unread" forState:UIControlStateNormal];
        }
        else
        {
            [self.markAsReadUnreadBtn setTitle:@"Mark As Read" forState:UIControlStateNormal];
        }
        
        [self.popOverView setHidden:NO];
        
        [UIView animateWithDuration: 0.2 animations:^{
            [self.popOverView setAlpha:1];
        }];
    
    }
    
    if([self.editBtn.titleLabel.text isEqualToString:@"Edit"])
    {
        editCells = true;
        goBackCells = false;
        [self.editBtn setTitle:@"Action" forState:UIControlStateNormal];
        [self.backBtn setHidden:NO];
        [self.homeBtn setHidden:YES];
        [self.tableView reloadData];
    }
}

bool goBackCells = false;

- (IBAction)backBtnPressed:(id)sender
{
    editCells = false;
    goBackCells = true;
    [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [self.backBtn setHidden:YES];
    [self.homeBtn setHidden:NO];
    [self.tableView reloadData];
}

- (IBAction)markAsReadUnreadBtnPressed:(id)sender
{
    NSDictionary *dict;
    NSIndexPath *indexPath;
    NotificationCustomCell *cell;
    
    if ([self.markAsReadUnreadBtn.titleLabel.text isEqualToString:@"Mark As Unread"])
    {
        for (int i = 0; i < [selectedRowsArray count]; i++)
        {
            indexPath = [selectedRowsArray objectAtIndex:i];
            dict = [notificationsArray objectAtIndex:indexPath.row];
            dict[@"messages"][@"readMessage"] = @false;
            
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellMainView.backgroundColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    else
    {
        for (int i = 0; i < [selectedRowsArray count]; i++)
        {
            indexPath = [selectedRowsArray objectAtIndex:i];
            dict = [notificationsArray objectAtIndex:indexPath.row];
            dict[@"messages"][@"readMessage"] = @true;
            
            cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.cellMainView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0] ;
            cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
        }
    }
    [self hidePopOverView];
}

- (IBAction)deleteBtnPressed:(id)sender
{
    if ([selectedRowsArray count] > 0)
    {
        if ([notificationsArray count] > 0)
        {
            [self deleteAllSelectedMessages];
            [selectedRowsArray removeAllObjects];
            [self hidePopOverView];
        }
    }
}

-(void) deleteNotificationAtIndexPath:(NSIndexPath *)indexPath
{
    if ([selectedRowsArray containsObject:indexPath])
    {
        [selectedRowsArray removeObject:indexPath];
    }
    if (indexPath.row == previousSelectedIndexRowPath)
    {
        previousSelectedIndexRowPath = -1;
    }
    if (indexPath.row == selectedIndexRowPath)
    {
        selectedIndexRowPath = -1;
    }
    if (indexPath.row < selectedIndexRowPath)
    {
        selectedIndexRowPath = selectedIndexRowPath - 1;
    }
    
    [notificationsArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)deleteAllSelectedMessages
{
    NSLog(@"%lu",(unsigned long)[selectedRowsArray count]);
    NSMutableArray *orignalArray = notificationsArray;
    NSMutableArray *objectsArray = [[NSMutableArray alloc] init];
    NSIndexPath *indexPath ;
    
    for (int i = 0; i < [selectedRowsArray count]; i++)
    {
        indexPath = [selectedRowsArray objectAtIndex:i];
        [objectsArray addObject:[notificationsArray objectAtIndex:indexPath.row]];
    }
    
    for (NSDictionary *od in orignalArray) {
        for (NSDictionary *rd in objectsArray) {
            if (od == rd) {
                [orignalArray removeObject:od];
            }
        }
    }
    
    [self.tableView reloadData];
    //[self.tableView deleteRowsAtIndexPaths:@[indexPaths] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)removeItem:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

- (IBAction)cancelBtnPressed:(id)sender
{
    [self hidePopOverView];
}

-(void) hidePopOverView
{
    [UIView animateWithDuration: 0.2 animations:^{
        [self.popOverView setAlpha:0];
    }completion:^(BOOL finished){
        
        [self.popOverView setHidden:YES];
        if ([notificationsArray count] == 0)
        {
            [self.editBtn setHidden:YES];
            [self.backBtn setHidden:YES];
            [self.homeBtn setHidden:NO];
        }
    }];
}

-(BOOL) isAtleastOneUnreadMessageSelected
{
    NSDictionary *dict;
    BOOL unreadFound = FALSE;
    
    for (int i = 0 ; i < [selectedRowsArray count] ; i++)
    {
        NSIndexPath *indexPath = [selectedRowsArray objectAtIndex:i];
        dict = [notificationsArray objectAtIndex:indexPath.row];
        if( ![[dict objectForKey:@"readMessage"] integerValue] )
        {
            unreadFound = TRUE;
            break;
        }
    }
    return unreadFound;
}

@end
