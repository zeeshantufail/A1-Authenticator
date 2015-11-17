//
//  NotificationViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/6/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIButton    * backBtn;
@property (weak, nonatomic) IBOutlet UIButton    * editBtn;


- (IBAction)editBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

@end
