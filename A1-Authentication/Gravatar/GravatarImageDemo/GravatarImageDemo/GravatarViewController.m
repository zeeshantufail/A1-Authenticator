//
//  ViewController.m
//  GravatarImageDemo
//
//  Created by Rudd Fawcett on 12/10/13.
//  Copyright (c) 2013 Rudd Fawcett. All rights reserved.
//

#import "GravatarViewController.h"
#import "RFGravatarImageView.h"

@interface GravatarViewController ()

@property (strong,nonatomic) RFGravatarImageView *imageView;

@end

@implementation GravatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"RFGravatarImageView";
    
    _imageView = [[RFGravatarImageView alloc] initWithFrame:self.view.bounds];
    _imageView.email = @"test@test.com";
    _imageView.forceDefault = YES;
    _imageView.defaultGravatar = RFDefaultGravatarMysteryMan;
    _imageView.size = 1024;
    
    [self.view addSubview:_imageView];
    
    [_imageView load];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLoad)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapToLoad {
//    _imageView.email = @"rudd.fawcett@gmail.com";
    
    _imageView.email = @"zeeshantufail86@yahoo.com";
    _imageView.forceDefault = NO;
    [_imageView refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
