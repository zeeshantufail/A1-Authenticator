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

@interface NotificationViewController ()
{
    NSInteger selectedIndexRowPath;
    NSMutableArray *notificationsArray;
    NSMutableArray *notificationsDataViews;
    NSMutableArray *selectedRowsArray;
}

@end

@implementation NotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.popOverView setHidden:YES];
    [self.popOverView setAlpha:0];
    
    [self.backBtn setHidden:YES];
    
    selectedIndexRowPath = -1;
}

#pragma - mark table datasource and delagte

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == selectedIndexRowPath)
    {
        UIView *v = [notificationsDataViews objectAtIndex:indexPath.row];
        return v.frame.size.height+60;
    }
    return 60.0;
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
    [cell.selectionBtn setTag:indexPath.row];
    
    cell.image_View.layer.cornerRadius  = 21   ;
    cell.image_View.layer.masksToBounds = YES  ;
    
    UIView *dataView = [self notificationDataForRowAtIndexPath:indexPath forCell:cell];
    [cell.cellMainView addSubview:dataView];
    
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame)-20, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
    [cell.contentView addSubview:separatorLineView];
    
    [self animateCell:cell atIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.popOverView.hidden == NO) {
        self.popOverView.hidden = YES;
    }
    
    if (indexPath.row == selectedIndexRowPath)
    {
        selectedIndexRowPath = -1;
    }
    else
    {
        selectedIndexRowPath = indexPath.row ;
    }
    
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
    
    l1.text = @"Your OTP has been updated";
    l2.text = @"Your new code is 4556789";
    l3.text = @"This code was issued at 05:45:45 and will last for 60 seconds";
    l4.text = @"The Access One team";
    
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

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

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
        
//        MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"Trash" backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
        
//            NSIndexPath * indexPath = [me.tableView indexPathForCell:sender];
//            [me deleteMail:indexPath];
//            return NO; //don't autohide to improve delete animation
//        }];

        
        MGSwipeButton * deleteBtn = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor colorWithRed:0.97 green:0.58 blue:0.11 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            [cell hideSwipeAnimated:YES];
            return NO;
        }];
        
        MGSwipeButton * readBtn = [MGSwipeButton buttonWithTitle:@"Mark as\nread" backgroundColor:[UIColor colorWithRed:0.29 green:0.28 blue:0.28 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            
            //[self.tableView indexPathForCell:sender]];

            [cell refreshContentView];
            return YES;
        }];
        
        
        return @[deleteBtn, readBtn];
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
    
    if([self image:checkBoxBtn.imageView.image isEqualTo:[UIImage imageNamed:@"deselect.png"]])
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
//        [selectedRowsArray addObject:[notificationsArray objectAtIndex:[sender tag]]];
    }
    else
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"deselect.png"] forState:UIControlStateNormal];
        
//        if ([selectedRowsArray containsObject:[notificationsArray objectAtIndex:[sender tag]]])
//        {
//            [selectedRowsArray removeObject:[notificationsArray objectAtIndex:[sender tag]]];
//        }
    }
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
    if ([self.editBtn.titleLabel.text isEqualToString:@"Action"])
    {
        [self.popOverView setHidden:NO];
        
        [UIView animateWithDuration: 0.2 animations:^{
            //[self.popOverView setHidden:NO];
            [self.popOverView setAlpha:1];
            //self.popOverView.frame = CGRectMake(x,self.view.frame.size.height - h ,195,129);
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
}

- (IBAction)deleteBtnPressed:(id)sender
{
}

- (IBAction)cancelBtnPressed:(id)sender
{
    [UIView animateWithDuration: 0.2 animations:^{
        [self.popOverView setAlpha:0];
//        self.popOverView.frame = CGRectMake(((self.tableView.frame.size.width/2)-(self.popOverView.frame.size.width/2)),self.view.frame.size.height - h ,0,0);
    }completion:^(BOOL finished){
        
        [self.popOverView setHidden:YES];
    }];
}

@end
