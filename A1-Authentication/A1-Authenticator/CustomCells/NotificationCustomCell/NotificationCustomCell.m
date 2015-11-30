//
//  NotificationCustomCell.m
//  A1-Authenticator
//
//  Created by Waqar on 11/6/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "NotificationCustomCell.h"
#import "AppHelper.h"

@implementation NotificationCustomCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        //float rowHeight ;
        
        if ([AppHelper isIphone5])
        {
            //rowHeight = 150;
        }
        else if ([AppHelper isIphone6])
        {
            //rowHeight = 179;
        }
        else
        {
            //rowHeight = 199;
        }
        
//        self.cellMainView.frame = CGRectMake(self.cellMainView.frame.origin.x,
//                                             self.cellMainView.frame.origin.y,
//                                             self.cellMainView.frame.size.width, rowHeight);
    }
}

@end
