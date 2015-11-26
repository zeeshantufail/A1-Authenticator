//
//  WelcomeAppViewController.m
//  
//
//  Created by Waqar on 11/2/15.
//
//

#import "WelcomeAppViewController.h"
#import "BeginViewController.h"
#import "VideoViewController.h"
#import "AnimationHelper.h"


@interface WelcomeAppViewController ()

@end

int numberOfPages = 3;

@implementation WelcomeAppViewController

@synthesize h1,h2;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:self.temporaryImageView];
    
    [self performSelector:@selector(removeTemporaryImageView) withObject:nil afterDelay:0.5];

    VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    [self addChildViewController:videoViewController];
    [self.videoView addSubview:videoViewController.view];
    
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage   = 0;
}

-(void)removeTemporaryImageView
{
    [self.temporaryImageView setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self animateLogo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setPagesInScrollView];
    
    [self.videoView bringSubviewToFront:self.scrollView];
    [self.videoView bringSubviewToFront:self.pageControl];
    [self.videoView bringSubviewToFront:self.beginButton];
    [self.videoView bringSubviewToFront:self.logoImageView];
}


-(void)viewDidDisappear:(BOOL)animated
{
}

-(void)animateLogo
{
    self.logoImageView.image = [UIImage imageNamed:@"Authenticator_Logo_24.png"];
    
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"Authenticator_Logo_0.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_1.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_2.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_3.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_4.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_5.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_6.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_7.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_8.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_9.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_10.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_11.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_12.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_13.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_14.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_15.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_16.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_17.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_18.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_19.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_20.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_21.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_22.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_23.png"],
                             [UIImage imageNamed:@"Authenticator_Logo_24.png"],
                             nil];
    
    self.logoImageView.animationImages=animationArray;
    self.logoImageView.animationDuration=1.5;
    self.logoImageView.animationRepeatCount = 1;
    [self.logoImageView startAnimating];
    
    [[AnimationHelper sharedInstance] performSelector:@selector(animateButton:) withObject:self.beginButtonContainer afterDelay:1.5];
}

#pragma Mark - HelperMethods

- (CGRect)getScreenFrameForCurrentOrientation
{
    return [self getScreenFrameForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect fullScreenRect = [[UIScreen mainScreen] bounds];
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    if (! [UIApplication sharedApplication].statusBarHidden )
    {
        CGFloat statusBarHeight = 20;
        fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}

-(void) setPagesInScrollView
{
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    self.pageControl.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    for (int i = 0; i < numberOfPages; i++)
    {
        CGRect screenRect = [self getScreenFrameForCurrentOrientation] ; //[[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        //CGFloat screenHeight = screenRect.size.height;
        
        CGRect frame;
        
        frame.origin.x = screenWidth * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;

        
        UIView *textContainer = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, screenWidth,self.scrollView.frame.size.height)];
        
        if ([AppHelper isIphone5])
        {
            h1 = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 320, 48)];
            h2 = [[UILabel alloc] initWithFrame:CGRectMake(0 , 46, 320, 60)];
            
            [h1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
            [h2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        }
        if ([AppHelper isIphone6])
        {
            h1 = [[UILabel alloc] initWithFrame:CGRectMake(0 ,0 ,375 ,61)];
            h2 = [[UILabel alloc] initWithFrame:CGRectMake(0 ,61 ,375 ,80)];
            
            [h1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
            [h2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
        }
        if ([AppHelper isIphone6p])
        {
            h1 = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0, 414, 68)];
            h2 = [[UILabel alloc] initWithFrame:CGRectMake(0 , 66, 414, 88)];
            
            [h1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
            [h2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        }
        
        h1.numberOfLines = 2;
        h1.textAlignment = NSTextAlignmentCenter;
        h1.textColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.184 alpha:1];
        h1.backgroundColor=[UIColor clearColor];
        
        h2.numberOfLines = 3;
        h2.textAlignment = NSTextAlignmentCenter;
        h2.textColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.184 alpha:0.8];
        h2.backgroundColor=[UIColor clearColor];
        
        NSString *labelHeadingText;
        NSString *labelSubHeadingText;
        NSMutableAttributedString *attributedString;
        NSMutableParagraphStyle *paragraphStyle;
        NSMutableAttributedString *attributedString2;
        NSMutableParagraphStyle *paragraphStyle2;
        
        switch (i)
        {
            case 0:

                if ([AppHelper isIphone6])
                {
                    h1.frame = CGRectMake(0 ,0 ,375 ,61);
                    h2.frame = CGRectMake(0 ,50 ,375 ,80);
                }
                
                labelHeadingText = @"Strong Authentication in\n the palm of your hand";
                
                attributedString = [[NSMutableAttributedString alloc] initWithString:labelHeadingText];
                paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:4];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelHeadingText length])];
                h1.attributedText = attributedString ;

                labelSubHeadingText = @"Log in to all of your secured web\n apps quickly and securely";
                
                attributedString2 = [[NSMutableAttributedString alloc] initWithString:labelSubHeadingText];
                paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle2 setLineSpacing:5];
                paragraphStyle2.alignment = NSTextAlignmentCenter;
                [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [labelSubHeadingText length])];
                h2.attributedText = attributedString2 ;
                
                break;
            case 1:

                if ([AppHelper isIphone5])
                {
                    h1.frame = CGRectMake(0, 0, 320, 48);
                    h2.frame = CGRectMake(0, 55, 320, 60 );
                }
                
                labelHeadingText = @"Your apps, your choice\nof security";
                attributedString = [[NSMutableAttributedString alloc] initWithString:labelHeadingText];
                paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:4];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelHeadingText length])];
                h1.attributedText = attributedString ;
                labelSubHeadingText = @"Easily switch between One-Time\n Passcode and QR authentication\n depending on your preference";
                
                attributedString2 = [[NSMutableAttributedString alloc] initWithString:labelSubHeadingText];
                paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle2 setLineSpacing:5];
                paragraphStyle2.alignment = NSTextAlignmentCenter;
                [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [labelSubHeadingText length])];
                h2.attributedText = attributedString2 ;
                
                break;
            case 2:
                
                if ([AppHelper isIphone5])
                {
                    h1.frame = CGRectMake(0, 0, 320, 48);
                    h2.frame = CGRectMake(0, 55, 320, 60 );
                }
                
                labelHeadingText = @"To get started, just link\n to your Access: One account";

                attributedString = [[NSMutableAttributedString alloc] initWithString:labelHeadingText];
                paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:4];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelHeadingText length])];
                h1.attributedText = attributedString ;
                
                labelSubHeadingText = @"Log in to Access: One on your computer\n and follow the instructions you’ve been\n given to link your authenticator";
                
                attributedString2 = [[NSMutableAttributedString alloc] initWithString:labelSubHeadingText];
                paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle2 setLineSpacing:5];
                paragraphStyle2.alignment = NSTextAlignmentCenter;
                [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [labelSubHeadingText length])];
                h2.attributedText = attributedString2 ;
                break;
                
            default:
                break;
        }

        [textContainer addSubview:h1];
        [textContainer addSubview:h2];
        
        CGRect newFrame = CGRectMake(textContainer.frame.origin.x, textContainer.frame.origin.y, textContainer.frame.size.width, h1.frame.size.height + h2.frame.size.height);

        textContainer.frame = newFrame;
        
        [self.scrollView addSubview:textContainer];
    }
    
    [self resetContentSizeOfScrollView];
}

-(void)resetContentSizeOfScrollView
{
    float sizeOfContent = 0;
    UIView *lv = [self.scrollView.subviews lastObject];
    NSInteger ln = lv.frame.origin.x;
    NSInteger wd = lv.frame.size.width;
    
    sizeOfContent = wd+ln;
    
    self.scrollView.contentSize = CGSizeMake(sizeOfContent, self.scrollView.frame.size.height);
    
    NSLog(@"scrol view width %.f",self.scrollView.contentSize.width);
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

#pragma Mark - actions

- (IBAction)beginBtnTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[AppHelper getStoryboardName] bundle:nil];
    BeginViewController *beginViewController = [storyboard instantiateViewControllerWithIdentifier:@"BeginViewController"];
    [self.navigationController pushViewController:beginViewController animated:YES];
    
//    BeginViewController *beginViewController = [[BeginViewController alloc] init];
//    [self.navigationController pushViewController:beginViewController animated:YES];
}

@end
