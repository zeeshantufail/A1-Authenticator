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
#import "AnimationHelper.h"
#import "AppSettings.h"

@interface ThankYouViewController ()
{
    NSString * name;
    NSString * designation;
}
@end

@implementation ThankYouViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self drawCircle];
    
    name = [NSString stringWithFormat:@"%@ %@", [[AppSettings sharedAppSettings] appUserFirstName], [[AppSettings sharedAppSettings]  appUserLastName]];
    designation = [NSString stringWithFormat:@"%@, %@", [[AppSettings sharedAppSettings] appUserDesignation], [[AppSettings sharedAppSettings] appRegName]];
    self.designationLbl.text = designation;
    UIImage *gravatarImage = [[AppSettings sharedAppSettings] appGravatarImage];
    if (gravatarImage) {
        [[AppSettings sharedAppSettings] setAppGravatarImage:gravatarImage];
    }
    
    [self performAnimations];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadGravatar];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)loadGravatar{
    [[AppSettings sharedAppSettings] setAppUserEmail:[[AppSettings sharedAppSettings] appUserEmail]];
    if (![GravatarLoader gravatarImage]) {
        [[GravatarLoader sharedInstance] loadGravatarWithEmail:[[AppSettings sharedAppSettings] appUserEmail] andSender:self];
    }
    else{
        [self imageLoaded:[GravatarLoader gravatarImage]];
    }
}

-(void)imageLoaded:(UIImage *)img{
    if(img)
    {
        self.profileImageView.image = img;
        [[AppSettings sharedAppSettings] setAppGravatarImage:img];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//-(void) drawCircle
//{
//    // Set up the shape of the circle
//    int radius = 100;
//    CAShapeLayer *circle = [CAShapeLayer layer];
//    // Make a circular shape
//    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
//                                             cornerRadius:radius].CGPath;
//    // Center the shape in self.view
//    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
//                                  CGRectGetMidY(self.view.frame)-radius);
//    
//    // Configure the apperence of the circle
//    circle.fillColor = [UIColor clearColor].CGColor;
//    //circle.strokeColor = [UIColor blackColor].CGColor;
//    circle.strokeColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:0.8].CGColor;
//    circle.lineWidth = 5;
//    
//    // Add to parent layer
//    [self.view.layer addSublayer:circle];
//    
//    // Configure animation
//    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    drawAnimation.duration            = 0.1; // "animate over 10 seconds or so.."
//    drawAnimation.repeatCount         = 1.0;  // Animate only once..
//    
//    // Animate from no part of the stroke being drawn to the entire stroke being drawn
//    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
//    
//    // Experiment with timing to get the appearence to look the way you want
//    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    // Add the animation to the circle
//    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
//    
//    [self drawCircle2];
//}
//
//-(void) drawCircle2
//{
//    // Set up the shape of the circle
//    int radius = 100;
//    CAShapeLayer *circle = [CAShapeLayer layer];
//    // Make a circular shape
//    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
//                                             cornerRadius:radius].CGPath;
//    // Center the shape in self.view
//    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
//                                  CGRectGetMidY(self.view.frame)-radius);
//    
//    // Configure the apperence of the circle
//    circle.fillColor = [UIColor clearColor].CGColor;
//    //circle.strokeColor = [UIColor whiteColor].CGColor;
//    circle.strokeColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0].CGColor;
//    circle.lineWidth = 7;
//    
//    // Add to parent layer
//    [self.view.layer addSublayer:circle];
//    
//    // Configure animation
//    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    drawAnimation.duration            = 10.0; // "animate over 10 seconds or so.."
//    drawAnimation.repeatCount         = 1.0;  // Animate only once..
//    
//    // Animate from no part of the stroke being drawn to the entire stroke being drawn
//    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
//    
//    // Experiment with timing to get the appearence to look the way you want
//    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    
//    // Add the animation to the circle
//    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
//}

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
    self.profileImageView.layer.cornerRadius = 65.0;
    self.profileImageView.layer.masksToBounds = YES;
    
    [self animateUpperColorView];
    
    [self.profileImageView setHidden:YES];
    [self.designationLbl setHidden:YES];
    [self.textsContainerView setAlpha:0];
    self.textsContainerView.frame = CGRectMake(self.textsContainerView.frame.origin.x, self.textsContainerView.frame.origin.y - 15, self.textsContainerView.frame.size.width, self.textsContainerView.frame.size.height);
    
    if ([AppHelper isIphone6p])
    {
        self.profileImageView.layer.cornerRadius = 88.0;
        [self performSelector:@selector(animateProfileImage) withObject:self afterDelay:1.0 ];
        
    }
    else if ([AppHelper isIphone6])
    {
        self.profileImageView.layer.cornerRadius = 80.0;
        [self performSelector:@selector(animateProfileImage) withObject:self afterDelay:1.0 ];
    }
    else
    {
        [self performSelector:@selector(animateProfileImage) withObject:self afterDelay:0.6 ];
    }
    
    
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
                            [self animateNameShowText:name characterDelay:0.01];
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
        
    }completion:^(BOOL finished)
     {
         [self showTextsContainerView];
     }];
}

-(void) showTextsContainerView
{
    [UIView transitionWithView:self.designationLbl duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        
        [self.textsContainerView setAlpha:1];
        self.textsContainerView.frame = CGRectMake(self.textsContainerView.frame.origin.x, self.textsContainerView.frame.origin.y + 15, self.textsContainerView.frame.size.width, self.textsContainerView.frame.size.height);
    
    }completion:^(BOOL finished)
     {
         [[AnimationHelper sharedInstance] performSelector:@selector(animateButton:) withObject:self.pinButtonContainer afterDelay:0.0];
     }];
    
    
//    [UIView animateWithDuration:0.6 animations:^() {
//        
//    }completion:^(BOOL finished)
//     {
//         [self.textsContainerView setHidden:NO];
//     }];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[AppHelper getStoryboardName] bundle:nil];
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
    
    [self.thankyouLowerContentView setHidden:YES];
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
