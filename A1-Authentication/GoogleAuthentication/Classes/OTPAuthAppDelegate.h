//
//  OTPAuthAppDelegate.h
//
//  Copyright 2011 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "RootViewController.h"
#import "OTPAuthURLEntryController.h"

typedef enum {
  kOTPNotEditing,
  kOTPEditingSingleRow,
  kOTPEditingTable
} OTPEditingState;

@interface OTPAuthAppDelegate : NSObject
    <UIApplicationDelegate,
    OTPAuthURLEntryControllerDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate>
@property(nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property(nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) IBOutlet UINavigationController *authURLEntryController;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *legalButton;
@property(nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property(nonatomic, retain) IBOutlet UINavigationItem *authURLEntryNavigationItem;
@property (nonatomic, assign) RootViewController *rootViewController;

- (IBAction)addAuthURL:(id)sender;
- (IBAction)showLegalInformation:(id)sender;
+(OTPAuthAppDelegate *)sharedDelegate;

@end
