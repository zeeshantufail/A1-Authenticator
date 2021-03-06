//
//  SettingsViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/9/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "SettingsViewController.h"

#import "AppHelper.h"

#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "ResetAppViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import "KeyboardViewController.h"
#import "PasscodeHelper.h"
#import "AppSettings.h"


@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SettingsViewController
{
    NSArray *_menuItems;
    BOOL touchIDFlag, pinFlag, qryptoFlag, totpFlag, setPinFlag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileImageView.layer.cornerRadius = 35.0;
    self.profileImageView.layer.masksToBounds = YES  ;
    
    if ([AppHelper isIphone6p])
    {
        self.revealViewController.rearViewRevealWidth = 325;
        self.profileImageView.layer.cornerRadius = 45.0;
    }
    if ([AppHelper isIphone6])
    {
        self.revealViewController.rearViewRevealWidth = 295;
        self.profileImageView.layer.cornerRadius = 40.0;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.revealViewController.rearViewRevealOverdraw = 0;
    self.revealViewController.toggleAnimationDuration = 0.3;
    self.revealViewController.toggleAnimationType = SWRevealToggleAnimationTypeEaseOut;
    self.revealViewController.frontViewShadowRadius = 5;
    
    if ([GravatarLoader gravatarImage]) {
        [self imageLoaded:[GravatarLoader gravatarImage]];
    }
    else{
        [[GravatarLoader sharedInstance] loadGravatarWithEmail:[[AppSettings sharedAppSettings] appUserEmail] andSender:self];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[AppSettings sharedAppSettings] appUserFirstName], [[AppSettings sharedAppSettings] appUserLastName]];
    self.designationLabel.text = [NSString stringWithFormat:@"%@, %@", [[AppSettings sharedAppSettings] appUserDesignation], [[AppSettings sharedAppSettings] appRegName]];
}

-(void)imageLoaded:(UIImage *)img{
    
    if(img)
    self.profileImageView.image = img;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options: UIViewAnimationCurveEaseOut
//                     animations:^{
//                         
//                         self.view.frame = CGRectMake(-768, 0, 320, 364);
//                     }
//                     completion:^(BOOL finished){
//                     }];
}

-(void)viewDidAppear:(BOOL)animated{
    [self reloadTableView];
}

-(void)reloadTableView{
    
    setPinFlag = [[AppSettings sharedAppSettings] appPinCreated];
    pinFlag    = [[AppSettings sharedAppSettings] appPinState];
    totpFlag   = [[AppSettings sharedAppSettings] appTotp];
    
    if (setPinFlag)
    {
        _menuItems = @[@"HomeCell", @"AuthenticationTypeCell", @"AppSecurityCell", @"ChangeMyPinCell",@"AuditHistoryCell", @"ResetMyDeviceCell", @"HelpCell",@"AboutCell"];
    }
    else
    {
        _menuItems = @[@"HomeCell", @"AuthenticationTypeCell", @"AppSecurityCell", @"AuditHistoryCell", @"ResetMyDeviceCell", @"HelpCell",@"AboutCell"];
    }
    
    [self.tableView reloadData];

}

-(void)viewWillDisappear:(BOOL)animated
{
//    [UIView animateWithDuration:0.4 animations:^{
//        
//        self.view.frame = CGRectMake(768, 0, 320, 364);
//        
//    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2)
    {
        if ([AppHelper isIphone6])
        {
            return 85.0f;
        }
        else if ([AppHelper isIphone6p])
        {
            return 100.0f;
        }
        else
        {
            return 80.0f;
        }
    }
    else if ([AppHelper isIphone6])
    {
        return 38.0f;
    }
    else if ([AppHelper isIphone6p])
    {
        return 44.0f;
    }
    else
    {
        return 34.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 1 || indexPath.row == 2 )
    {
        [self setActionsToButtonsOfCell:cell atIndexPath:indexPath];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self highlightCellLabel:indexPath.row];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if( !([identifier isEqualToString:@"setPinScreenThroughSettingSegue"] && [[AppSettings sharedAppSettings] appPinCreated]) )
    {
        return true;
    }
    else{
        
        [[AppSettings sharedAppSettings] setAppTouchID:NO];
        [[AppSettings sharedAppSettings] setAppPinState:YES];
        
        [self reloadTableView];
        return false;
    }
}

-(void)setActionsToButtonsOfCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        UIButton *qryptoButton = [cell viewWithTag:201];
        UIButton *otpButton    = [cell viewWithTag:202];
        
        [qryptoButton addTarget:self action:@selector(qryptoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [otpButton addTarget:self action:@selector(otpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (totpFlag)
        {
            [otpButton setBackgroundImage:[UIImage imageNamed:@"TOTP_Icon_ON.png"] forState:UIControlStateNormal];
            [qryptoButton setBackgroundImage:[UIImage imageNamed:@"QR_Icon_OFF.png"] forState:UIControlStateNormal];
        }
        else
        {
            [otpButton setBackgroundImage:[UIImage imageNamed:@"TOTP_Icon_OFF.png"] forState:UIControlStateNormal];
            [qryptoButton setBackgroundImage:[UIImage imageNamed:@"QR_Icon_ON.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        UIButton *touchIDButton = [cell viewWithTag:301];
        UIButton *pinButton    = [cell viewWithTag:302];
        
        [touchIDButton addTarget:self action:@selector(touchIDButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pinButton addTarget:self action:@selector(pinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if (pinFlag)
        {
            [pinButton setBackgroundImage:[UIImage imageNamed:@"PIN_Icon_ON.png"] forState:UIControlStateNormal];
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"TOUCH_Icon_OFF.png"] forState:UIControlStateNormal];
        }
        else
        {
            [pinButton setBackgroundImage:[UIImage imageNamed:@"PIN_Icon_OFF.png"] forState:UIControlStateNormal];
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"TOUCH_Icon_ON.png"] forState:UIControlStateNormal];
        }
    }
}

-(void)highlightCellLabel:(NSInteger)rowNo
{
    for (NSInteger i = 0; i < 8; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:index];
        UILabel *label = [cell viewWithTag:100];
        
        if (i == rowNo)
        {
            label.textColor = [UIColor whiteColor];
        }
        else
        {
            label.textColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
        }
    }
}

-(void)qryptoButtonPressed:(UIButton*)sender
{
    NSLog(@"qryptoButtonPressed");
}

-(void)otpButtonPressed:(UIButton*)sender
{
    NSLog(@"otpButtonPressed");
}

-(void)touchIDButtonPressed:(UIButton*)sender
{
    NSLog(@"touchIDButtonPressed");
}

-(void)pinButtonPressed:(UIButton*)sender
{
    NSLog(@"pinButtonPressed");
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"setPinScreenThroughSettingSegue"])
    {
        //[[segue destinationViewController] setDelegate:self];
        KeyboardViewController *kbc = (KeyboardViewController *)[segue destinationViewController];
        PasscodeHelper *pc = [[PasscodeHelper alloc] init];
        [pc loadContent];
        pc.passcodeScreenState.screenNumber = 0;
        pc.passcodeScreenState.screenType = 2;
        pc.passcodeScreenState.error = false;
        
        kbc.passcodeHelper = pc;
    }
    else  if ([[segue identifier] isEqualToString:@"changePinScreenSegue"])
    {
        //[[segue destinationViewController] setDelegate:self];
        KeyboardViewController *kbc = (KeyboardViewController *)[segue destinationViewController];
        PasscodeHelper *pc = [[PasscodeHelper alloc] init];
        [pc loadContent];
        pc.passcodeScreenState.screenNumber = 0;
        pc.passcodeScreenState.screenType = 3;
        pc.passcodeScreenState.error = false;
        
        kbc.passcodeHelper = pc;
    }
    else if([[segue identifier] isEqualToString:@"qrScanViewSegue"]){
        QRCodeScanViewController *qrVC = (QRCodeScanViewController *)[segue destinationViewController];
        qrVC.delegate = self;
        qrVC.isTotp = NO;
    }
    else if([[segue identifier] isEqualToString:@"totpScanViewSegue"]){
        QRCodeScanViewController *qrVC = (QRCodeScanViewController *)[segue destinationViewController];
        qrVC.delegate = self;
        qrVC.isTotp = YES;
    }
}

-(void)didScanResult:(QRCodeScanViewController *)qrCodeScanViewController{
    [qrCodeScanViewController.revealViewController revealToggle:qrCodeScanViewController];
}

-(void)didDismissQrScan:(QRCodeScanViewController *)qrCodeScanViewController{
    [qrCodeScanViewController.revealViewController revealToggle:qrCodeScanViewController];
    
}

- (IBAction)touchIdAction:(id)sender {
    [[AppSettings sharedAppSettings] setAppTouchID:YES];
    [[AppSettings sharedAppSettings] setAppPinState:NO];
    
    [self reloadTableView];
}

- (IBAction)activateOtp:(id)sender {
    [[AppSettings sharedAppSettings] setAppTotp:YES];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self reloadTableView];
    
    [self performSegueWithIdentifier:@"homeViewSegue" sender:self];
}

- (IBAction)activateQR:(id)sender {
    [[AppSettings sharedAppSettings] setAppTotp:NO];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self reloadTableView];
    [self performSegueWithIdentifier:@"homeViewSegue" sender:self];
}
@end
