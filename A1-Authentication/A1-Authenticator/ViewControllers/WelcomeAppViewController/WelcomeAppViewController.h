//
//  WelcomeAppViewController.h
//  
//
//  Created by Waqar on 11/2/15.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@interface WelcomeAppViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView   * logoImageView;

@property (weak, nonatomic) IBOutlet UIView        * videoView;
@property (weak, nonatomic) IBOutlet UIScrollView  * scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl * pageControl;
@property (weak, nonatomic) IBOutlet UIButton      * beginButton;

@property (retain, nonatomic) UILabel * h1;
@property (retain, nonatomic) UILabel * h2;

- (IBAction)beginBtnTapped:(id)sender;

@end



