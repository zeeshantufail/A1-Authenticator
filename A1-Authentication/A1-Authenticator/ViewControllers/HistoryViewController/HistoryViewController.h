//
//  HistoryViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/10/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)settingsBtnPressed:(id)sender;
- (IBAction)clearHistoryBtnPressed:(id)sender;

@end
