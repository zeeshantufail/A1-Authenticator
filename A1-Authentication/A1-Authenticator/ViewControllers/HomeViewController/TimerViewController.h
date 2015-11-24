//
//  TimerViewController.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 19/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController
{
    NSTimer * sTOTPTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *countDownImageView;

-(void)showTimer;
@end
