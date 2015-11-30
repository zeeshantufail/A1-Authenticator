//
//  GravatarLoader.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 27/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFGravatarImageView.h"

@protocol GravatarLoaderDelegate <NSObject>

-(void)imageLoaded:(UIImage *)img;

@end


@interface GravatarLoader : NSObject<GravatarLoaderDelegate>

@property id<GravatarLoaderDelegate> delegate;

+(GravatarLoader *)sharedInstance;
+(UIImage *)gravatarImage;

-(void)loadGravatarWithEmail:(NSString *)email andSender:(id<GravatarLoaderDelegate>)sender;
@end
