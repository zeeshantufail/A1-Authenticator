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
        self.profileImageView.layer.cornerRadius = 45.0;
    }
    
    if (setPinFlag)
    {
        _menuItems = @[@"HomeCell", @"AuthenticationTypeCell", @"AppSecurityCell", @"ChangeMyPinCell",@"AuditHistoryCell", @"ResetMyDeviceCell", @"HelpCell",@"AboutCell"];
    }
    else
    {
        _menuItems = @[@"HomeCell", @"AuthenticationTypeCell", @"AppSecurityCell", @"AuditHistoryCell", @"ResetMyDeviceCell", @"HelpCell",@"AboutCell"];
    }
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if ([AppHelper isIphone6p])
    {
        self.revealViewController.rearViewRevealWidth = 325;
    }
    
    self.revealViewController.rearViewRevealOverdraw = 0;
    self.revealViewController.toggleAnimationDuration = 0.3;
    self.revealViewController.toggleAnimationType = SWRevealToggleAnimationTypeEaseOut;
    self.revealViewController.frontViewShadowRadius = 5;
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
    
    setPinFlag = true;
    pinFlag    = true;
    totpFlag   = true;
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
        if ([AppHelper isIphone5])
        {
            return 80.0f;
        }
        if ([AppHelper isIphone6p])
        {
            return 100.0f;
        }
    }
    if ([AppHelper isIphone5])
    {
        return 34.0f;
    }
    return 44.0f;
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
    return !([identifier isEqualToString:@"setPinScreenThroughSettingSegue"] && [[AppSettings sharedAppSettings] appPinState]);
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
}

@end
