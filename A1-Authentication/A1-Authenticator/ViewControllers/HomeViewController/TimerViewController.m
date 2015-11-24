//
//  TimerViewController.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 19/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "TimerViewController.h"

@interface ImageClass : NSObject
@property (nonatomic) UIImage * image;
@property (nonatomic) NSString * imageName;
+(ImageClass *)imageNamed:(NSString *)name;
@end

@implementation ImageClass

+(ImageClass *)imageNamed:(NSString *)name{
    ImageClass * ic = [ImageClass new];
    ic.imageName = name;
    ic.image = [UIImage imageNamed:name];
    return ic;
}

@end

@implementation TimerViewController

NSMutableArray *imagesBuff1;
NSMutableArray *imagesBuff2;
NSMutableArray *images;

float fps = 30;
float period = 60;
int totalImages = 1800;

int imagesLoadInMemory = 60;
int currentBuffer = 0;
int nextBufferLoadBeforeImagesRemaining = 50;

-(void)viewDidLoad{
    [self showTimer];
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)viewDidDisappear:(BOOL)animated{
//    [sTOTPTimer invalidate];
//    sTOTPTimer = nil;
}

-(void)showTimer{
    [self loadImages];
    sTOTPTimer = [NSTimer scheduledTimerWithTimeInterval:(0.03)
                                                  target:self
                                                selector:@selector(totpTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)loadImages{
    
    double time = [[NSDate date] timeIntervalSince1970];
    int seconds = (int)time;
    
    float fraction = time - seconds;
    
    //    NSTimeInterval delta = [[NSDate date] timeIntervalSince1970];
    uint64_t progress = (uint64_t)time % (uint64_t)period;
    
    float currentDelta = progress + fraction;
    int imageNumber = round(currentDelta/period * totalImages)-1;
    currentBuffer = imageNumber / imagesLoadInMemory;
    
    NSLog(@"%d %d %f", imageNumber, currentBuffer, currentDelta);
    
    imagesBuff1 = [[NSMutableArray alloc] init];
    imagesBuff2 = [[NSMutableArray alloc] init];
    int si = currentBuffer * imagesLoadInMemory;
    int li = si + imagesLoadInMemory;
    for (int c = si; c < li; c++) {
        [imagesBuff1 addObject:[ImageClass imageNamed: [ NSString stringWithFormat:@"Countdown_Animation/Countdown_Animation_%.5d.png", c ]]];
    }
    
    
    si = (currentBuffer+1) * imagesLoadInMemory;
    li = si + imagesLoadInMemory;
    for (int c = si; c < li; c++) {
        [imagesBuff2 addObject:[ImageClass imageNamed: [ NSString stringWithFormat:@"Countdown_Animation/Countdown_Animation_%.5d.png", c ]]];
    }
    images = imagesBuff1;
    
}


-(void)loadImagesForBuffer:(NSMutableArray *)imageBuffer{
    [imageBuffer removeAllObjects];
        int si = 0;
    if (currentBuffer + 1 < totalImages / imagesLoadInMemory ) {
        
        si = (currentBuffer + 1 ) * imagesLoadInMemory;
    }
        int li = si + imagesLoadInMemory;
        for (int c = si; c < li; c++) {
            [imageBuffer addObject:[ImageClass imageNamed: [ NSString stringWithFormat:@"Countdown_Animation/Countdown_Animation_%.5d.png", c ]]];
        }

    
}

-(void)swapBuffers{
    if (images == imagesBuff1) {
        images = imagesBuff2;
        
        [self loadImagesForBuffer:imagesBuff1];
        [self performSelectorInBackground:@selector(loadImagesForBuffer:) withObject:imagesBuff1];
    }
    else if(images == imagesBuff2){
        images = imagesBuff1;
        [self performSelectorInBackground:@selector(loadImagesForBuffer:) withObject:imagesBuff2];
    }
}

-(BOOL)shouldSwap{
    if ((currentBuffer % 2 == 0 && images != imagesBuff1) || (currentBuffer % 2 == 1 && images != imagesBuff2)) {
        return true;
    }
    else{
        return false;
    }
}

-(ImageClass *)getImageForDelta:(float)currentDelta{
    
    currentDelta = (float)((int)(currentDelta * 1000)% (int)(period*1000)) / 1000; //confirming the right delta
    
    int imageNumber = round(currentDelta/period * totalImages)-1;
    
    currentBuffer = imageNumber / imagesLoadInMemory;  //totalImages / imagesLoadInMemory  - totalImages / (imageNumber+1);
    
    int imagesTopLimit = imagesLoadInMemory * (currentBuffer +1);
    int imagesBottomLimit = imagesTopLimit - imagesLoadInMemory;
    
//    if (imageNumber >= imagesTopLimit) {
//        currentBuffer = imageNumber % imagesLoadInMemory;
//        imagesTopLimit = imagesLoadInMemory * (currentBuffer +1);
//        imagesBottomLimit = imagesTopLimit - imagesLoadInMemory;
//        [self loadImages];
//    }
//    else if( imageNumber < imagesBottomLimit){
//        currentBuffer = imageNumber % imagesLoadInMemory;
//        imagesTopLimit = imagesLoadInMemory * (currentBuffer +1);
//        imagesBottomLimit = imagesTopLimit - imagesLoadInMemory;
//        [self loadImages];
//    }
//    
    int arrayImageNumber = imageNumber % imagesLoadInMemory;
    if ([self shouldSwap]) {
        NSLog(@"%d %d %f", imageNumber, currentBuffer, currentDelta);
        [self swapBuffers];
    }
    
    ImageClass * img;
    if (imageNumber >= 0) {
        img = images[arrayImageNumber];
    }
    else{
        img = [ImageClass imageNamed: [ NSString stringWithFormat:@"Countdown_Animation_00000.png"]];
    }
    
    
    
    return img;
}

- (void)totpTimer:(NSTimer *)timer {
    /*
    TOTPGenerator *generator = (TOTPGenerator *)[self generator];
    NSTimeInterval delta = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval period = [generator period];
    uint64_t progress = (uint64_t)delta % (uint64_t)period;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (progress == 0 || progress > self.lastProgress) {
        [nc postNotificationName:OTPAuthURLDidGenerateNewOTPNotification object:self];
        self.lastProgress = period;
        self.warningSent = NO;
    } else if (progress > period - self.generationAdvanceWarning
               && !self.warningSent) {
        NSNumber *warning = [NSNumber numberWithInt:ceil(period - progress)];
        NSDictionary *userInfo
        = [NSDictionary dictionaryWithObject:warning
                                      forKey:OTPAuthURLSecondsBeforeNewOTPKey];
        
        [nc postNotificationName:OTPAuthURLWillGenerateNewOTPWarningNotification
                          object:self
                        userInfo:userInfo];
        self.warningSent = YES;
    }
     */
    
    double time = [[NSDate date] timeIntervalSince1970];
    int seconds = (int)time;
    
    float fraction = time - seconds;
    
//    NSTimeInterval delta = [[NSDate date] timeIntervalSince1970];
    uint64_t progress = (uint64_t)time % (uint64_t)period;
    
    float currentDelta = progress + fraction;
    
    ImageClass *img = [self getImageForDelta:currentDelta];
    NSLog(@"%f %@", currentDelta, img.imageName);
    
    self.countDownImageView.image = img.image;
    
    if (progress == 0 || progress > period) {
        
    }
    else if (progress > period - 15 ) {
        
    }
}


@end
