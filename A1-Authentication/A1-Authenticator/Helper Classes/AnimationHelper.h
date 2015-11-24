//
//  AnimationHelper.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 24/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationHelper : NSObject
-(void)animateButton:(UIView *)buttonContainer;
+(AnimationHelper*)sharedInstance;
@end
