//
//  HelpViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/10/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "HelpViewController.h"
#import "SWRevealViewController.h"
#import "VideoViewController.h"
#import "HelpPage1ViewController.h"
#import "HelpPage2ViewController.h"
#import "HelpPage3ViewController.h"
#import "AppHelper.h"

@interface HelpViewController ()
{
    VideoViewController *videoViewController;
}
@end

int numberOf_Pages = 3;

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view bringSubviewToFront:self.settingsBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    
    videoViewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    [self addChildViewController:videoViewController];
    [self.videoView addSubview:videoViewController.view];
}

-(void)viewDidDisappear:(BOOL)animated{
    [videoViewController removeFromParentViewController];
    [videoViewController.view removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setPagesInScrollView];
    [self addTapGesture];
    
    [self.videoView bringSubviewToFront:self.scrollView];
    [self.videoView bringSubviewToFront:self.pageControl];
}

-(void)addTapGesture
{
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    
    [self.scrollView addGestureRecognizer:tap];
}

-(void)setPagesInScrollView
{
    self.scrollView.delegate = self;
    self.pageControl.numberOfPages = numberOf_Pages;
    self.pageControl.currentPage   = 0;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[AppHelper getStoryboardName] bundle:nil];
    
    HelpPage1ViewController *helpPage1ViewController = [storyboard instantiateViewControllerWithIdentifier:@"HelpPage1ViewController"];
    HelpPage2ViewController *helpPage2ViewController = [storyboard instantiateViewControllerWithIdentifier:@"HelpPage2ViewController"];
    HelpPage3ViewController *helpPage3ViewController = [storyboard instantiateViewControllerWithIdentifier:@"HelpPage3ViewController"];
    
    for(int i=0; i < numberOf_Pages; i++)
    {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview;
        
        if (i==0)
        {
            subview = [[UIView alloc] initWithFrame:frame];
            [self addChildViewController:helpPage1ViewController];
            [subview addSubview:helpPage1ViewController.view];
            helpPage1ViewController.view.alpha = 0.8;
        }
        else if(i==1)
        {
            subview = [[UIView alloc] initWithFrame:frame];
            [self addChildViewController:helpPage2ViewController];
            [subview addSubview:helpPage2ViewController.view];
            helpPage2ViewController.view.alpha = 0.8;
        }
        else
        {
            subview = [[UIView alloc] initWithFrame:frame];
            [self addChildViewController:helpPage3ViewController];
            [subview addSubview:helpPage3ViewController.view];
            helpPage3ViewController.view.alpha = 0.8;
        }
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * numberOf_Pages, self.scrollView.frame.size.height);
}

#pragma Mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)settingsBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

@end
