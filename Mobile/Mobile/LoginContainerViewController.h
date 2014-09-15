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



@interface LoginContainerViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) IBOutlet UIButton *forgotPassword;
extern NSMutableArray *globalCurrentUser;
@property (retain, nonatomic) NSMutableData *responseData;
-(IBAction)  forgot_password;


@property (weak, nonatomic) IBOutlet UIView *container;

@property (nonatomic) BOOL successful_login;

-(IBAction)submit;










@end
