//
//  QRCodeScanViewController.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 04/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "AppSettings.h"
#import "QRStorage.h"
#import "SWRevealViewController.h"
#import "TargetConditionals.h"
#import "SettingsViewController.h"
//#import "OTPAuthURLEntryController.h"

@interface QRCodeScanViewController ()
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;

@end

@implementation QRCodeScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    
    if(!_isReading)
    {
        if (!TARGET_IPHONE_SIMULATOR)
        {
            _isReading = YES;
            [self startReading];
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
}

-(void)viewDidAppear:(BOOL)animated{
    if (TARGET_IPHONE_SIMULATOR) {
        if (![self.delegate isKindOfClass:[SettingsViewController class]]) {
            //[self.delegate didScanResult:self];
            NSString *dummyQR = @"";
            [self QRScanned:dummyQR];
            [[AppSettings sharedAppSettings] setAppTotp:self.isTotp];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
//            [_bbitemStart setTitle:@"Stop"];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        // The bar button item's title should change again.
//        [_bbitemStart setTitle:@"Start!"];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}

- (IBAction)crossButtonAction:(id)sender {
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate didDismissQrScan:self];
}


#pragma mark - Private method implementation
AVCaptureDeviceInput *input;
- (BOOL)startReading {
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    

    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    
    CGPoint scanSP = self.scanView.frame.origin;
    CGPoint scanLP = CGPointMake(scanSP.x + self.scanView.frame.size.width, scanSP.y + self.scanView.frame.size.height);
    CGPoint cameraSize = CGPointMake(self.view.frame.size.width, self.view.frame.size.height);
    
    
    CGRect frame = CGRectMake(scanSP.y / cameraSize.y
                              , 1 - (scanLP.x / cameraSize.x)
                              , scanLP.y /cameraSize.y - scanSP.y / cameraSize.y , (1 - scanSP.x / cameraSize.x) - (1 - (scanLP.x / cameraSize.x)));
    
    captureMetadataOutput.rectOfInterest = frame;//CGRectMake(0.2, 0, 1, 0.4);
    
//    frame = self.scanView.frame;
//    
//    frame = [self.viewPreview convertRect:frame toView:self.view];
    
    NSLog(@"%f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
//    
//    AVCaptureConnection *previewLayerConnection=_videoPreviewLayer.connection;
//    
//    if ([previewLayerConnection isVideoOrientationSupported])
//        [previewLayerConnection setVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
//    [_captureSession startRunning];
    
    [_captureSession performSelector:@selector(startRunning) withObject:nil afterDelay:0.5];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}

-(void)QRScanned:(NSString *)result{
    
    UILabel * waitLabel = (UILabel *)[self.view viewWithTag:2];
    [waitLabel setHidden:NO];
    
    ScanCodeHelper *sch = [[ScanCodeHelper alloc] init];
    sch.delegate = self;
    NSString *dummyQR = @"UserKey:a1test:asim:y:4:9:602a19ddd02cba1f2aab69c495b34fab:http%3A%2F%2F116.58.50.114%3A9632%2FLogin%2Frest%2Fworkflow%2Fqrauthtest:12345"; //todo zeeshan
    [sch scanKeyWithResultingString:dummyQR];
    
}
#pragma mark - scanCodeHelper

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}


- (void)setKey:(NSString*)key {
    QRStorage *storage = [[QRStorage alloc] init];
    storage.appKey = key;
    NSMutableData *data = [[NSMutableData alloc] init] ;
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data] ;
    [archiver encodeObject:storage forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


- (void)scanCodeHelper:(ScanCodeHelper*)scanCodeHelper keyScannedWithRegisterationName:(NSString*)regName userName:(NSString*)userName applicationKey:(NSString*)key authenticationUrl:(NSString*)url pinRequired:(BOOL)pinRequired pinLength:(NSInteger)pinLength resetCount:(NSInteger)resetCount regID:(NSString *) regId{
    
    [self setKey:key];
    
    [[AppSettings sharedAppSettings] setAppRegName:regName];
    [[AppSettings sharedAppSettings] setAppUserName:userName];
    [[AppSettings sharedAppSettings] setAppPinState:NO];
    [[AppSettings sharedAppSettings] setPinLength:pinLength];
    [[AppSettings sharedAppSettings] setApplicationAuthenticationUrl:url];
    [[AppSettings sharedAppSettings] setAppRegId:regId];
    if (resetCount > 0) {
        [[AppSettings sharedAppSettings] setResetAppNum:resetCount];
        [[AppSettings sharedAppSettings] enableResetAppCount:NO];
    }
    
    
    [self.delegate didScanResult:self];
    [[AppSettings sharedAppSettings] setAppTotp:self.isTotp];
    
//    AuthenticateUser *au = [[AuthenticateUser alloc] init];
//    au.delegate = self;
//    [au authenticateUser];

}

#pragma mark - authenticateUser delegates

-(void)userAuthenticatedSuccessfully:(AuthenticateUser *)authenticateUser{
    
    UILabel * waitLabel = (UILabel *)[self.view viewWithTag:2];
    [waitLabel setHidden:YES];
    
    [self.delegate authenticationCompleted:self];
}

-(void)userAuthenticationFailed:(AuthenticateUser *)authenticateUser{
    [self.delegate authenticationFailed:self];
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0 && _isReading) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            //[_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(QRScanned:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
//            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            
            _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayer) {
                [_audioPlayer play];
            }
        }
    }
    
    
}

@end