//
//  SetPinViewController.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 12/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "SetPinViewController.h"

@interface SetPinViewController ()

@end

@implementation SetPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.keyboardViewController = [[KeyboardViewController alloc] initWithNibName:@"KeyboardViewController" bundle:nil];
    
    
    
}

    UIView *subview;
-(void)viewWillAppear:(BOOL)animated{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    self.keyboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"KeyboardViewController"];
    [self addChildViewController:self.keyboardViewController];
    self.keyboardViewController.delegate = self;
    
////    [self.keyboardViewController.view setBackgroundColor: [UIColor greenColor]];
////    self.keyboardViewController.view.frame = self.view.frame;
////    self.keyboardViewController.view.alpha = 1;
////    self.keyboardViewController.view.hidden = NO;
//    NSLog(@"%@",self.keyboardViewController.view);
////    self.keyboardViewController.keypadAndCirclesContainer.frame = self.keypadView.frame;
//    [self.mainView addSubview:self.keyboardViewController.view];
    
    
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.mainView.frame.size;
    

    
    subview = [[UIView alloc] initWithFrame:frame];
    [self addChildViewController:self.keyboardViewController];
    [subview addSubview:self.keyboardViewController.view];
    
    subview.center = self.mainView.center;
    
    [self.mainView addSubview:subview];
    [self.mainView bringSubviewToFront:subview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:self.mainView];
    [self.mainView bringSubviewToFront:subview];
}


#pragma mark - Keyboard controller delegates
-(void)pinCanceled{
    
}

-(void)pinEntered:(NSString *)pin{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch ;
    touch = [[event allTouches] anyObject];
    
    
    NSLog(@"%@", touch.view );
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
