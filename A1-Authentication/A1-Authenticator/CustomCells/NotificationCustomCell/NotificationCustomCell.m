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
        if (self.dayLabel.hidden)
        {
            NSString *dayLabel = self.subtitle2.text;
            self.subtitle2.text = self.dayLabel.text;
            self.dayLabel.text = dayLabel;
            [self.dayLabel setHidden:NO];
        }
        else
        {
            NSString *dayLabel = self.dayLabel.text;
            self.dayLabel.text = self.subtitle2.text;
            self.subtitle2.text = dayLabel;
            [self.dayLabel setHidden:YES];
        }
    }
}

@end
