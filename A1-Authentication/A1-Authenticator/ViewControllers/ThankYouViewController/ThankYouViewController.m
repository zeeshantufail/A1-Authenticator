//
//  ThankYouViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/5/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "ThankYouViewController.h"
#import "KeyboardViewController.h"
#import "PasscodeHelper.h"
#import "AppHelper.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//-(void)viewDidLayoutSubviews
//{
//    CGRect frame;
//    
//    if ([AppHelper isIphone5])
//    {
//        [self.pairedTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
//        frame = self.pairedTitle.frame;
////        frame.origin.x = 30;
//        frame.origin.y = 280; //286
////        frame.size = self.pairedTitle.frame.size;
//        self.pairedTitle.frame = frame;
//        
//        if (self.view.tag == 1)
//        {
//            [self.detail1TextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
//            [self.detail2TextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
//            
//            frame = self.detail1TextView.frame;
//            
//            frame.origin.x = 60;
//            frame.origin.y = 330;
//            frame.size.width = 200; //self.detail1TextView.frame.size;
//            frame.size.height = 52;
//            self.detail1TextView.frame = frame;
//            
//            frame = self.detail2TextView.frame;
//            
//            frame.origin.y = 370;
//            frame.size = self.detail2TextView.frame.size;
//            self.detail2TextView.frame = frame;
//        }
//        else
//        {
//            [self.questionTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
//            
//            frame.origin.x = 15;
//            frame.origin.y = 330;
//            frame.size = self.questionTextView.frame.size;
//            self.questionTextView.frame = frame;
//            
//            frame.origin.x = 90;
//            frame.origin.y = 370;
//            frame.size = self.touchIDBtn.frame.size;
//            self.touchIDBtn.frame = frame;
//            
//            frame.origin.x = 90;
//            frame.origin.y = 435;
//            frame.size = self.securePINBtn.frame.size;
//            self.securePINBtn.frame = frame;
//        }
//    }
//}

#pragma Mark - Helper Methods

-(void)performAnimations
{
    self.profileImageView.layer.cornerRadius = 68.0;
    self.profileImageView.layer.masksToBounds = YES  ;
    
    [self animateUpperColorView];
    
    [self.profileImageView setHidden:YES];
    [self.designationLbl setHidden:YES];
    
    [self performSelector:@selector(animateProfileImage) withObject:self afterDelay:0.6 ];
}

-(void)animateUpperColorView
{
    self.upperColorImageView.image = [UIImage imageNamed:@"GREY PANEL_00023.png"];
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"GREY PANEL_00005.png"],
                             [UIImage imageNamed:@"GREY PANEL_00006.png"],
                             [UIImage imageNamed:@"GREY PANEL_00007.png"],
                             [UIImage imageNamed:@"GREY PANEL_00008.png"],
                             [UIImage imageNamed:@"GREY PANEL_00009.png"],
                             [UIImage imageNamed:@"GREY PANEL_00010.png"],
                             [UIImage imageNamed:@"GREY PANEL_00011.png"],
                             [UIImage imageNamed:@"GREY PANEL_00012.png"],
                             [UIImage imageNamed:@"GREY PANEL_00013.png"],
                             [UIImage imageNamed:@"GREY PANEL_00014.png"],
                             [UIImage imageNamed:@"GREY PANEL_00015.png"],
                             [UIImage imageNamed:@"GREY PANEL_00016.png"],
                             [UIImage imageNamed:@"GREY PANEL_00017.png"],
                             [UIImage imageNamed:@"GREY PANEL_00018.png"],
                             [UIImage imageNamed:@"GREY PANEL_00019.png"],
                             [UIImage imageNamed:@"GREY PANEL_00020.png"],
                             [UIImage imageNamed:@"GREY PANEL_00021.png"],
                             [UIImage imageNamed:@"GREY PANEL_00022.png"],
                             [UIImage imageNamed:@"GREY PANEL_00023.png"],
                             nil];
    
    self.upperColorImageView.animationImages=animationArray;
    self.upperColorImageView.animationDuration=0.6;
    self.upperColorImageView.animationRepeatCount = 1;
    [self.upperColorImageView startAnimating];
}

-(void)animateProfileImage
{
    [self.profileImageView setHidden:NO];
    
    self.profileImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.profileImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished)
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                        ^{
                            [self animateNameShowText:@"Mei Andrews" characterDelay:0.01];
                        });
     }];
}

- (void)animateNameShowText:(NSString*)newText characterDelay:(NSTimeInterval)delay
{
    for (int i=0; i< newText.length; i++)
    {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.nameLbl setText:[NSString stringWithFormat:@"%@%C", self.nameLbl.text, [newText characterAtIndex:i]]];
                       });
        
        [NSThread sleepForTimeInterval:delay];
    }
    
    [NSThread sleepForTimeInterval:0.4];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self showDesignationLabel];
                   });
}

-(void)showDesignationLabel
{
    [UIView transitionWithView:self.designationLbl duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        
        [self.designationLbl setHidden:NO];
        
    } completion:nil];
    
//    [UIView animateWithDuration:0.6 animations:^() {
//        self.designationLbl.alpha = 1.0;
//    }];
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"setPinSegue"])
    {
        //[[segue destinationViewController] setDelegate:self];
        KeyboardViewController *kbc = (KeyboardViewController *)[segue destinationViewController];
        PasscodeHelper *pc = [[PasscodeHelper alloc] init];
        [pc loadContent];
        pc.passcodeScreenState.screenNumber = 0;
        pc.passcodeScreenState.screenType = 0;
        pc.passcodeScreenState.error = false;
        
        kbc.passcodeHelper = pc;
    }
    if ([[segue identifier] isEqualToString:@"setTouchIdSegue"])
    {
        //[[segue destinationViewController] setDelegate:self];
        KeyboardViewController *kbc = (KeyboardViewController *)[segue destinationViewController];
        PasscodeHelper *pc = [[PasscodeHelper alloc] init];
        [pc loadContent];
        pc.passcodeScreenState.screenNumber = 0;
        pc.passcodeScreenState.screenType = 4;
        pc.passcodeScreenState.error = false;
        
        kbc.passcodeHelper = pc;
    }
}


#pragma MARK - actions

- (IBAction)touchIDBtnPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KeyboardViewController *authViewController = [storyboard instantiateViewControllerWithIdentifier:@"authenticationViewController"];
    
    PasscodeHelper *pc = [[PasscodeHelper alloc] init];
    [pc loadContent];
    pc.passcodeScreenState.screenNumber = 0;
    pc.passcodeScreenState.screenType = 4;
    pc.passcodeScreenState.error = false;
    
    authViewController.passcodeHelper = pc;
    
    [self addChildViewController:authViewController];
    [self.view addSubview:authViewController.view];
    authViewController.view.hidden = YES;
}

//
//- (IBAction)securePINBtnPressed:(id)sender
//{
//    if([self image:[sender backgroundImageForState:UIControlStateNormal] isEqualTo:[UIImage imageNamed:@"SecurePIN_ON.png"]])
//    {
//        [sender setBackgroundImage:[UIImage imageNamed:@"SecurePIN_OFF.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.touchIDBtn setBackgroundImage:[UIImage imageNamed:@"TouchID_OFF.png"] forState:UIControlStateNormal];
//        
//        [sender setBackgroundImage:[UIImage imageNamed:@"SecurePIN_ON.png"] forState:UIControlStateNormal];
//    }
//}

@end
