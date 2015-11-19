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

@interface NotificationViewController ()
{
    NSMutableArray *cellsOnLeftSide;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.backBtn setUserInteractionEnabled:NO];
    
    cellsOnLeftSide = [[NSMutableArray alloc] init];
    [self setUpLeftSwipe];
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
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"notificationCell";
    NotificationCustomCell *cell = (NotificationCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NotificationCustomCell" owner:self options:nil] objectAtIndex:0];
    }
    
    [cell.selectionBtn addTarget:self action:@selector(checkBoxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.selectionBtn setTag:indexPath.row];
    
    cell.image_View.layer.cornerRadius  = 21   ;
    cell.image_View.layer.masksToBounds = YES  ;
    
    [self animateCell:cell atIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)checkBoxBtnClick:(id)sender
{
    UIButton *checkBoxBtn = (UIButton*) sender;
    
    if([self image:checkBoxBtn.imageView.image isEqualTo:[UIImage imageNamed:@"deselect.png"]])
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    }
    else
    {
        [checkBoxBtn setImage:[UIImage imageNamed:@"deselect.png"] forState:UIControlStateNormal];
    }
}

- (void)setUpLeftSwipe
{
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    NotificationCustomCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.cellMainView.frame.origin.x == -36)
    {
        [UIView animateWithDuration: 0.5 animations:^{
            cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x - 164, cell.cellMainView.center.y);
        }];

        [cell setNeedsLayout];
        
        [cellsOnLeftSide addObject:indexPath];
    }
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    NotificationCustomCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.cellMainView.frame.origin.x == -200)
    {
        [UIView animateWithDuration: 0.5 animations:^{
            cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x + 164, cell.cellMainView.center.y);
        }];
        
        [cell setNeedsLayout];
        
        [cellsOnLeftSide removeObject:indexPath];
    }
}

-(void) animateCell:(NotificationCustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cellsOnLeftSide containsObject:indexPath])
    {
        if (cell.cellMainView.frame.origin.x == -36)
        {
            cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x - 164, cell.cellMainView.center.y);
        }
    }
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
                cell.cellMainView.center = CGPointMake(cell.cellMainView.center.x + 164 + 36, cell.cellMainView.center.y);
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

bool editCells = false;

- (IBAction)settingsBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

- (IBAction)editBtnPressed:(id)sender
{
    if([self.editBtn.titleLabel.text isEqualToString:@"Edit"])
    {
        editCells = true;
        goBackCells = false;
        [cellsOnLeftSide removeAllObjects];
        [self.editBtn setTitle:@"Action" forState:UIControlStateNormal];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"Back_Arrow_ON.png"] forState:UIControlStateNormal];
        [self.backBtn setUserInteractionEnabled:YES];
        [self.tableView reloadData];
    }
}

bool goBackCells = false;

- (IBAction)backBtnPressed:(id)sender
{
    editCells = false;
    goBackCells = true;
    [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:@"Back_Arrow_OFF.png"] forState:UIControlStateNormal];
    [self.backBtn setUserInteractionEnabled:NO];
    [self.tableView reloadData];
}

@end
