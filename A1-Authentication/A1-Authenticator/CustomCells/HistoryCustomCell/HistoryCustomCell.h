//
//  HistoryCustomCell.h
//  A1-Authenticator
//
//  Created by Waqar on 11/10/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * image_View;
@property (weak, nonatomic) IBOutlet UILabel     * dateTime;
@property (weak, nonatomic) IBOutlet UILabel     * performedAction;

@end
