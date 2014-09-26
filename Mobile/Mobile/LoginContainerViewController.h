//
//  LoginContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 5/28/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import <FacebookSDK/FacebookSDK.h>




@interface LoginContainerViewController : UIViewController <FBLoginViewDelegate>

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) IBOutlet UIButton *forgotPassword;
extern NSMutableArray *globalCurrentUser;
extern BOOL uses_keychain;
extern BOOL uses_facebook;
extern NSMutableDictionary *shnack_user_info;
@property (retain, nonatomic) NSMutableData *responseData;

@property (nonatomic, retain) KeychainItemWrapper *password;
@property (nonatomic, retain) KeychainItemWrapper *email;
@property (nonatomic, retain) KeychainItemWrapper *phone;
@property (nonatomic, retain) KeychainItemWrapper *name;
@property (nonatomic, retain) KeychainItemWrapper *auth_token;

-(IBAction)  forgot_password;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

- (void)
loginViewFetchedUserInfo:	(FBLoginView *)loginView
user:	(id<FBGraphUser>)user;


@property (weak, nonatomic) IBOutlet UIView *container;

@property (nonatomic) BOOL successful_login;

-(IBAction)submit;










@end
