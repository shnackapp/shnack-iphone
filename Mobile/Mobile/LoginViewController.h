//
//  LoginViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"


@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (retain, nonatomic) IBOutlet UIButton *Login;
//@property (weak, nonatomic) IBOutlet BButton *LoginButton;

@property (nonatomic) BOOL validEmail;
@property (nonatomic) BOOL validPassword;
@property (nonatomic) BOOL validPhone;


@end
