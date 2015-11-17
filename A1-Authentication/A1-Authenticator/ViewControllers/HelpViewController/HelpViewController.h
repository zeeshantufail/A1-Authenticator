//
//  HelpViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/10/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView         * videoView;
@property (weak, nonatomic) IBOutlet UIScrollView   * scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl  * pageControl;
@property (weak, nonatomic) IBOutlet UIButton       * settingsBtn;

- (IBAction)settingsBtnPressed:(id)sender;

@end



//AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//SWRevealViewController *viewController = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@""];
//delegate.window.rootViewController = viewController;