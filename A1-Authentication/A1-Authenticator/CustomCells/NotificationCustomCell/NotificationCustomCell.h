//
//  NotificationCustomCell.h
//  A1-Authenticator
//
//  Created by Waqar on 11/6/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface NotificationCustomCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIView      * cellMainView;
@property (weak, nonatomic) IBOutlet UIButton    * selectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView * image_View;

@property (weak, nonatomic) IBOutlet UILabel     * title;
@property (weak, nonatomic) IBOutlet UILabel     * subtitle1;
@property (weak, nonatomic) IBOutlet UILabel     * subtitle2;
@property (weak, nonatomic) IBOutlet UILabel     * dayLabel;

@end
