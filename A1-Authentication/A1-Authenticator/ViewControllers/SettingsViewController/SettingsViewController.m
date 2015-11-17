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

@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation SettingsViewController
{
    NSArray *_menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileImageView.layer.cornerRadius = 35.0;
    self.profileImageView.layer.masksToBounds = YES  ;
    
    _menuItems = @[@"HomeCell", @"AuthenticationTypeCell", @"AppSecurityCell", @"ChangeMyPinCell",@"AuditHistoryCell", @"ResetMyDeviceCell", @"HelpCell",@"AboutCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
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
        return 85.0f;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == 0)
    {
        HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.revealViewController pushFrontViewController:homeViewController animated:YES];
    }
    if (indexPath.row == 1)
    {
    }
    if (indexPath.row == 2)
    {
    }
    if (indexPath.row == 3)
    {
    }
    if (indexPath.row == 4)
    {
        HistoryViewController *historyViewController = [storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
        [self.revealViewController pushFrontViewController:historyViewController animated:YES];
    }
    if (indexPath.row == 5)
    {
        ResetAppViewController *resetAppViewController = [storyboard instantiateViewControllerWithIdentifier:@"ResetAppViewController"];
        [self.revealViewController pushFrontViewController:resetAppViewController animated:YES];
    }
    if (indexPath.row == 6)
    {
        HelpViewController *helpViewController = [storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        [self.revealViewController pushFrontViewController:helpViewController animated:YES];
    }
    if (indexPath.row == 7)
    {
        AboutViewController *aboutViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
        [self.revealViewController pushFrontViewController:aboutViewController animated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"setPinScreenThroughSettingSegue"])
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
