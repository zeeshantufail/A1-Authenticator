//
//  NotificationViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/6/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface NotificationViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIView      * popOverView;
@property (weak, nonatomic) IBOutlet UIButton    * markAsReadUnreadBtn;
@property (weak, nonatomic) IBOutlet UIButton    * deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton    * cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton    * homeBtn;
@property (weak, nonatomic) IBOutlet UIButton    * backBtn;
@property (weak, nonatomic) IBOutlet UIButton    * editBtn;

- (IBAction)settingsBtnPressed:(id)sender;

- (IBAction)homeBtnPressed:(id)sender;
- (IBAction)editBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

- (IBAction)markAsReadUnreadBtnPressed:(id)sender;
- (IBAction)deleteBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;

@end
