//
//  KeyboardViewController.m
//  Mobile IAM
//
//  Created by Zeeshan Tufail on 20/02/2015.
//  Copyright (c) 2015 Intagleo Systems. All rights reserved.
//

#import "KeyboardViewController.h"
//#import "PassCodeViewControllerHelper.h"
#import "AnimeHelper.h"
#import "AppHelper.h"
#import "AppSettings.h"
#import "SetPinViewController.h"
#import "PasscodeHelper.h"

@interface KeyboardViewController ()
{
    SetPinViewController *passCodeViewController;
    UIDeviceOrientation orientation;
    NSMutableString *passCode;
}
@end

@implementation KeyboardViewController
@synthesize deleteButtonOutlet;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    
    passCode = [[NSMutableString alloc] init];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    buttonBackgroundImageView = [[UIImageView alloc] init];
    [self.keyPadView addSubview:buttonBackgroundImageView];
    if([AppHelper isIPad])
        buttonBackgroundImageView.image = [UIImage imageNamed:@"PIN_Circle-ipad.png"];
    else
        buttonBackgroundImageView.image = [UIImage imageNamed:@"PIN_Circle.png"];
    
    [dotsView setImage:[UIImage imageNamed:@"startCircleImage.png"]];
     //(//)(1)(2)(3)(4)(5)
    [self.view setBackgroundColor:[UIColor clearColor]];
}

-(void)viewWillAppear:(BOOL)animated{
//    [self viewWillLayoutSubviews];
//    passCodeViewController = (PassCodeViewController*)self.parentViewController;
     //(//)(1)(2)(3)(4)(5)
//    if(passCodeViewController.passcodeScreen == PassCodeScreenEnterPin && [[AppSettings sharedAppSettings] appTouchID])
//    {
//        [self.view setHidden:YES];
//    }
    
    [self.passcodeHelper updatePINScreen:self];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
//    if ([AppHelper isDeviceTouchIDSetup] && passCodeViewController.passcodeScreen == PassCodeScreenCreatePin) {
//        [self.buttonCancel setHidden:NO];
//    }
//    else
//        [self.buttonCancel setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}
/*
-(void)viewWillLayoutSubviews{
    //self.view.frame = self.parentViewController.view.frame;
    
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        
        self.view.frame = CGRectMake(0, 0, 1024, 768);
    }
    else{
        
        self.view.frame = CGRectMake(0, 0, 768, 1024);
    }
    
    if ([passCodeViewController isInSettingView]) {
        CGRect frame = self.view.frame;
        frame.size = passCodeViewController.passcodeMainView.frame.size;
        self.view.frame = frame;
        
        frame = self.keypadAndCirclesContainer.frame;
        frame.origin = CGPointMake(30, 147);
        self.keypadAndCirclesContainer.frame = frame;
        
        return;
    }
    //self.view.frame = [[UIScreen mainScreen] bounds];
    if (!passCodeViewController.isWelcomApp) {
        return;
    }
    
    
    if (orientation == [AppHelper deviceOrientation]) {
        return;
    }
    
    orientation = [AppHelper deviceOrientation];
    
    if(orientation > 4 || orientation == 0)
        orientation = self.interfaceOrientation;
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        
        self.view.frame = CGRectMake(0, 0, 1024, 768);
        CGRect frame = self.keypadAndCirclesContainer.frame;
        frame.origin.y = 216;
        self.keypadAndCirclesContainer.frame = frame;
    }
    else{
        self.view.frame = CGRectMake(0, 0, 768, 1024);
        CGRect frame = self.keypadAndCirclesContainer.frame;
        frame.origin.y = 341;
        self.keypadAndCirclesContainer.frame = frame;
    }
}


- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    
    if([AppHelper deviceOrientation] > 4)
        return;
    [self viewDidLayoutSubviews];
}
*/

-(IBAction)buttonTouchDown:(id)sender {
    UIButton *b = (UIButton *)sender;
    buttonBackgroundImageView.alpha = 0;
    buttonBackgroundImageView.frame = b.frame;
    
    CGFloat backgroundDelta = 32;
//    buttonBackgroundImageView.frame = CGRectMake(buttonBackgroundImageView.frame.origin.x, buttonBackgroundImageView.frame.origin.y, buttonBackgroundImageView.frame.size.width-backgroundDelta, buttonBackgroundImageView.frame.size.height-backgroundDelta);
    buttonBackgroundImageView.frame = b.frame;
    buttonBackgroundImageView.center = b.center;
    //[self.keyPadView bringSubviewToFront:b];
    [self.keyPadView sendSubviewToBack:buttonBackgroundImageView];
    [UIView animateWithDuration:0.2
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         buttonBackgroundImageView.alpha = 0.3;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)deletePressed:(id)sender{
    if (passCode.length > 0) {
        [self reverseAnimateDotNo:(int)passCode.length];
        [passCode replaceCharactersInRange:NSMakeRange(passCode.length-1, 1) withString:@""];
    }
    
}

- (IBAction)buttonCancelAction:(id)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupPinScreenCancel" object:nil];
    [self.passcodeHelper authenticationCanceled];
}

- (IBAction)settingBtnPressed:(id)sender {
    
    [self.revealViewController revealToggle:sender];
}

- (IBAction)keyPressed:(id)sender{
    UIButton *b = (UIButton *)sender;
    [UIView animateWithDuration:0.1
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         buttonBackgroundImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    
    NSInteger pinLength = 4;
    
    if ([passCode length] == 4) {
        return;
    }
    pinLength = 4;
    if (passCode.length < pinLength) {
        [passCode appendString:[NSString stringWithFormat:@"%ld", (long)b.tag]];
    }
    
    if(passCode.length > 0)
        [self animateDotNo:(int)passCode.length];
    
    if ([passCode length] == pinLength) {
        [deleteButtonOutlet setEnabled:NO];
//        [self clearImageDots];
        
        [self.keyPadView setUserInteractionEnabled:NO];
        //0UIImage *image = [UIImage imageNamed:@"startCircleImage.png"];
        //dotsView.image = image;
        //[passCodeViewController performSelector:@selector(passcodeEnteringEnded) withObject:nil afterDelay:0.5];
        [self pinEntered:passCode];
    }
}

-(void)pinEntered:(NSString *)pin{
    
    [self.passcodeHelper passcodeEntered:pin];
//    [self runPositiveAnime];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)clearAlldata {
    passCode = [[NSMutableString alloc] initWithCapacity:4];
    //add by zeeshan
    [self performSelector:@selector(clearImageDots) withObject:nil afterDelay:0.5];
}
-(void)clearImageDots{
    [self performSelector:@selector(imageSet) withObject:nil afterDelay:0];
}

-(void)imageSet{
    
    [deleteButtonOutlet setEnabled:YES];
    if(!dotsView.image)
    {
    [dotsView setImage:[UIImage imageNamed:@"startCircleImage.png"] ];
    dotsView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^(void){
        dotsView.alpha = 1;
    }];
    }
    [self.keyPadView setUserInteractionEnabled:YES];
    //[self testAnime];
}

-(void)runPositiveAnime{
    NSMutableArray *positiveImages = [[NSMutableArray alloc] init];
    for(int i = 61; i <= 79; i++){
        [positiveImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PIN_Anim_Positive%.3d.png",i]]];
    }
    dotsView.animationImages = positiveImages;
    dotsView.animationDuration = 0.7;
    dotsView.animationRepeatCount = 1;
    dotsView.image = nil;//[positiveImages objectAtIndex:positiveImages.count-1];
    //self.passCodeViewController.dotsView.image = [positiveImages objectAtIndex:0];
    [dotsView startAnimating];
    [[AppSettings sharedAppSettings] playPositiveSound];
}

-(void)runNegativeAnime{
    NSMutableArray *negativeImages = [[NSMutableArray alloc] init];
    for(int i = 61; i <= 99; i++){
        [negativeImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"PIN_Anim_Negative%.3d.png",i]]];
    }
    dotsView.animationImages = negativeImages;
    dotsView.animationDuration = 1;
    dotsView.animationRepeatCount = 1;
    dotsView.image = [negativeImages objectAtIndex:negativeImages.count-1];
    [dotsView startAnimating];
    
    [[AppSettings sharedAppSettings] playNegativeSound];
}

-(void)animateDotNo:(int)dot{
    AnimeHelper *animeGap = [AnimeHelper new];
    animeGap.startPoint = (dot-1) * 15 +1;
    animeGap.endPoint = animeGap.startPoint + 12;
    NSMutableArray *animeImages = [[NSMutableArray alloc] init];
    NSString * imageName = @"";
    for(int i = animeGap.startPoint; i <= animeGap.endPoint; i++)
    {
        imageName = [NSString stringWithFormat:@"PIN_Anim_Negative%.3d.png", i];
        [animeImages addObject:[UIImage imageNamed:imageName]];
    }
    dotsView.animationDuration = 0.6;
    dotsView.animationRepeatCount = 1;
    dotsView.animationImages = animeImages;
    
    dotsView.image = [UIImage imageNamed:imageName];
    [dotsView startAnimating];
}

-(void)reverseAnimateDotNo:(int)dot{
    AnimeHelper *animeGap = [AnimeHelper new];
    animeGap.startPoint = (dot-1) * 15 ;
    animeGap.endPoint = animeGap.startPoint + 13;
    NSMutableArray *animeImages = [[NSMutableArray alloc] init];
    NSString * imageName = @"";
    int i;
    for( i = animeGap.endPoint; i >= animeGap.startPoint; i--)
    {
        imageName = [NSString stringWithFormat:@"PIN_Anim_Negative%.3d.png", i];
        [animeImages addObject:[UIImage imageNamed:imageName]];
    }
    if (i == -1 ) {
        imageName = @"startCircleImage.png";
    }
    dotsView.animationDuration = 0.6;
    dotsView.animationRepeatCount = 1;
    dotsView.animationImages = animeImages;
    
    dotsView.image = [UIImage imageNamed:imageName];
    [dotsView startAnimating];
    //[imageName release];
}

- (void)dealloc {
}
@end
