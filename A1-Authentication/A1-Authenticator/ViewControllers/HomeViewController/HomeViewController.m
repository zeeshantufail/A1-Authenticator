//
//  HomeViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/9/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "AppSettings.h"
#import "AppDelegate.h"


@interface HomeViewController ()
{
    BOOL isTotpView;
}

@property (strong,nonatomic) RFGravatarImageView *imageView;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerForNotificationServices];
    
    [self loadHomeViewContent];
    [self loadGravatar];
    [self addTapGesture];
    [self performAnimations];
    
}

-(void)loadGravatar{
    if (![GravatarLoader gravatarImage]) {
        [[GravatarLoader sharedInstance] loadGravatarWithEmail:[[AppSettings sharedAppSettings] appUserEmail] andSender:self];
    }
    else{
        [self imageLoaded:[GravatarLoader gravatarImage]];
    }
}

-(void)imageLoaded:(UIImage *)img{
    if(img)
    self.profileImageView.image = img;
}

-(void)viewDidDisappear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
    if (![[AppSettings sharedAppSettings] appActivationState]) {
        [[AppSettings sharedAppSettings] setAppActivationState:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addTapGesture
{
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    
    [self.view addGestureRecognizer:tap];
}

-(void)performAnimations
{
    self.profileImageView.layer.cornerRadius = 65.0;
    self.profileImageView.layer.masksToBounds = YES  ;
    
    if ([AppHelper isIphone6p])
    {
        self.profileImageView.layer.cornerRadius = 88.0;
    }
    if ([AppHelper isIphone6])
    {
        self.profileImageView.layer.cornerRadius = 80.0;
    }
    
    [self animateUpperColorView];
    
    [self.profileImageView setHidden:YES];
    
    [self.designationLabel setHidden:YES];
    
    [self.messageBtn setHidden:YES];
    
    //[self.designationLabel setAlpha:0];
    
    [self performSelector:@selector(animateProfileImage) withObject:self afterDelay:0.9 ];
    
    [self performSelector:@selector(animateMessageBtn) withObject:self afterDelay:1.2 ];
    
    [self performSelector:@selector(showMessageBtn) withObject:self afterDelay:1.3 ];
    
    [self performSelector:@selector(startNewMessageAnimation) withObject:self afterDelay:6.1 ];
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
                            [self animateNameShowText:@"Home to be implemented" characterDelay:0.01];
                        });
     }];
}

- (void)animateNameShowText:(NSString*)newText characterDelay:(NSTimeInterval)delay
{
    [self.nameLbl setText:@""];
    
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

-(void)animateMessageBtn
{
    self.messageImageView.image = [UIImage imageNamed:@"Message_0016.png"];
    
    NSMutableArray *animationArray = [[NSMutableArray alloc] init];
    
    for (int i=1 ; i<=16 ; i++)
    {
        [animationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Message_%.4d.png",i]]];
    }

    self.messageImageView.animationImages=animationArray;
    self.messageImageView.animationDuration= 0.8;
    self.messageImageView.animationRepeatCount = 1;
    [self.messageImageView startAnimating];
}

-(void)showMessageBtn
{
    [UIView transitionWithView:self.messageBtn duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        
        [self.messageBtn setHidden:NO];
        self.messageBtn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        
    } completion:nil];
}

-(void)showDesignationLabel
{
    [UIView transitionWithView:self.designationLabel duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void){
        
        [self.designationLabel setHidden:NO];
        
    } completion:nil];
}

-(void)startNewMessageAnimation
{
    self.messageImageView.image = [UIImage imageNamed:@"New_Message_0074.png"];
    
    NSMutableArray *animationArray = [[NSMutableArray alloc] init];
    
    for (int i=1 ; i<=74 ; i++)
    {
        [animationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"New_Message_%.4d.png",i]]];
    }
    
    self.messageImageView.animationImages=animationArray;
    self.messageImageView.animationDuration= 2.5;
    self.messageImageView.animationRepeatCount = 1;
    [self.messageImageView startAnimating];
    
    [self performSelector:@selector(animateButtonTitle) withObject:self afterDelay:2.6 ];
    animation_count = 0;
}

int animation_count = 0;

-(void)animateButtonTitle
{
    animation_count++;
    
    [UIView animateWithDuration:0.8f animations:^{
        
        self.messageBtn.transform = CGAffineTransformMakeScale(2.5,2.5);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.8f animations:^{
            
            self.messageBtn.transform = CGAffineTransformMakeScale(2.0,2.0);
            
        } completion:^(BOOL finished) {
        
            if (animation_count < 5)
            {
                [self animateButtonTitle];
            }
            
        }];
        
    }];
    
    
}

- (IBAction)messageBtnPressed:(id)sender {
}

- (IBAction)settingsBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

#pragma mark - qrcode scan delegates and definations

-(void)loadQrCodeContent{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[AppHelper getStoryboardName] bundle:nil];
    
    QRCodeScanViewController *qrCodeVC = [storyboard instantiateViewControllerWithIdentifier:@"qrHomeView"];
    qrCodeVC.delegate = self;
    
    [self addChildViewController:qrCodeVC];
    
    UIView * contentView = [qrCodeVC.view viewWithTag:11];
    
    [self.homeContentView addSubview:contentView];
    
    
}
-(void)loadTotpContent{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[AppHelper getStoryboardName] bundle:nil];
    
    TimerViewController *timerVC = [storyboard instantiateViewControllerWithIdentifier:@"totpHomeView"];
//    timerVC.delegate = self;
    
    [self addChildViewController:timerVC];
    
    
    [self.homeContentView addSubview:timerVC.view];
    
}

-(void)loadHomeViewContent
{
    isTotpView = [[AppSettings sharedAppSettings] appTotp];
    
    if (isTotpView)
    {
        [self loadTotpContent];
    }
    else
    {
        [self loadQrCodeContent];
    }
}

-(void)refreshHomeViewContent{
    
    BOOL newTotp = [[AppSettings sharedAppSettings] appTotp];
    
    if (newTotp != isTotpView) {
        if (newTotp) {
            [self loadTotpContent];
        }
        else{
            [self loadQrCodeContent];
        }
        
        isTotpView = newTotp;
    }
}

-(void)didScanResult:(NSString *)result{
    ScanCodeHelper *sch = [[ScanCodeHelper alloc] init];
    sch.delegate = self;
    [sch scanChallengeCodeScanResult:result];
}

-(void)didDismissQrScan:(QRCodeScanViewController *)qrCodeScanViewController{
    
}

-(void)scanCodeHelper:(ScanCodeHelper *)scanCodeHelper passCode:(NSString *)passCode{
    
    QRCodeScanViewController *codeScanView =  (QRCodeScanViewController *)[self.childViewControllers objectAtIndex:0];
    codeScanView.passcodeLabel.text = passCode;
    [UIView animateWithDuration:1 animations:^(void){
        codeScanView.oneTimePasscodeLabel.alpha = 1;
        codeScanView.passcodeLabel.alpha = 1;
    }];
    [codeScanView performSelector:@selector(readQRCode) withObject:nil afterDelay:4];
}

#pragma mark - notifications

-(void)registerForNotificationServices{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[AppSettings sharedAppSettings] appNotificationToken]) {
        [appDelegate updateNotificationDB];
    }
    else{
        [appDelegate registerForNotification];
    }
    
    
    
}

@end
