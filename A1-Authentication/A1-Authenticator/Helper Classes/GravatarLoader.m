//
//  GravatarLoader.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 27/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "GravatarLoader.h"

@implementation GravatarLoader

static GravatarLoader *gl;

+(GravatarLoader *)sharedInstance{
    if (!gl) {
        gl = [[GravatarLoader alloc] init];
    }
    return gl;
}

-(void)loadGravatarWithEmail:(NSString *)email andSender:(id<GravatarLoaderDelegate>)sender{
    RFGravatarImageView *_imageView = [[RFGravatarImageView alloc] init];
    _imageView.email = email;
    //    _imageView.forceDefault = NO;
    //    _imageView.defaultGravatar = RFDefaultGravatarMysteryMan;
    _imageView.size = 256;
    
    //    [self.view addSubview:_imageView];
    _imageView.delegate = self;
    self.delegate = sender;
    [_imageView load];
}
static UIImage *image;
+(UIImage *)gravatarImage{
    return image;
}
-(void)imageLoaded:(UIImage *)img{
    image = img;
    [self.delegate imageLoaded:img];
}
@end
