//
//  NotificationCustomCell.h
//  A1-Authenticator
//
//  Created by Waqar on 11/6/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView      * cellMainView;
@property (weak, nonatomic) IBOutlet UIButton    * selectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView * image_View;

@property (weak, nonatomic) IBOutlet UIButton    * markAsReadBtn;
@property (weak, nonatomic) IBOutlet UIButton    * deleteBtn;

@end
