//
//  LoginViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"


@interface LoginViewController : UITableViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (retain, nonatomic) IBOutlet UITextField *password;



@property (nonatomic) BOOL validEmail;
@property (nonatomic) BOOL validPassword;

@property (nonatomic) IBOutlet UILabel *loginEmailLabel;
@property (nonatomic) IBOutlet UILabel *loginPasswordLabel;


@end
