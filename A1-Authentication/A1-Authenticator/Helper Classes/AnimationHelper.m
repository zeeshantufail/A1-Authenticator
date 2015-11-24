//
//  AnimationHelper.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 24/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "AnimationHelper.h"

@implementation AnimationHelper

static AnimationHelper *ah;

+(AnimationHelper*)sharedInstance{
    if (!ah) {
        ah = [AnimationHelper new];
    }
    return ah;
}

-(void)animateButton:(UIView *)buttonContainer{
    //tag 31 button border 32 button label 33 button
    UIImageView *buttonBorder = (UIImageView *)[buttonContainer viewWithTag:31];
    if (buttonBorder) {
        NSMutableArray *images = [NSMutableArray new];
        for (int c = 1; c < 32; c++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"button_animation/%d.png", c]]];
        }
        buttonBorder.image = [images objectAtIndex:30];
        buttonBorder.animationImages = images;
        buttonBorder.animationDuration = 1.1;
        buttonBorder.animationRepeatCount = 1;
        [buttonBorder startAnimating];
        
        [self performSelector:@selector(animateButtonLabel:) withObject:buttonContainer afterDelay:1.1];
    }
    
}

-(void)animateButtonLabel:(UIView *)buttonContainer{
    UILabel *buttonLabel = (UILabel *)[buttonContainer viewWithTag:32];
    if (buttonLabel) {
        CGRect frame = buttonLabel.frame;
        CGRect oFrame = buttonLabel.frame;
        frame.origin.y -= frame.size.height/4;
        buttonLabel.frame = frame;
        buttonLabel.alpha = 0;
        
        [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            buttonLabel.frame = oFrame;
            buttonLabel.alpha = 1;
            
        } completion:^(BOOL finished)
         {
             UIButton * button = (UIButton *)[buttonContainer viewWithTag:33];
             [button setHidden:NO];
             //[buttonLabel setHidden:YES];
             
             //UIImageView *buttonBorder = (UIImageView *)[buttonContainer viewWithTag:31];
             //[buttonBorder setHidden:YES];
         }
         ];
    }
}
@end
