//
//  LoginViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"


<<<<<<< HEAD
@interface LoginViewController : UITableViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UILabel *emailLabel;
@property (nonatomic) IBOutlet UILabel *passwordLabel;

@property (retain, nonatomic) IBOutlet UITextField *password;

extern NSMutableArray *globalCurrentUser;

@property (nonatomic) BOOL successful_login;
@property (nonatomic) BOOL does_exist;
@property (nonatomic) BOOL valid_email;
@property (nonatomic) BOOL valid_password;

@property (nonatomic) IBOutlet UILabel *loginEmailLabel;
@property (nonatomic) IBOutlet UILabel *loginPasswordLabel;

@property (retain, nonatomic) NSData *receivedData;
=======
@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (retain, nonatomic) IBOutlet UIButton *Login;
//@property (weak, nonatomic) IBOutlet BButton *LoginButton;

@property (nonatomic) BOOL validEmail;
@property (nonatomic) BOOL validPassword;
@property (nonatomic) BOOL validPhone;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a


@end
