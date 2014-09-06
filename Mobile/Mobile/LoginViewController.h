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
@property (nonatomic) IBOutlet UILabel *emailLabel;

@property (nonatomic) IBOutlet UILabel *passwordLabel;
@property (retain, nonatomic) IBOutlet UITextField *password;

extern NSMutableArray *globalCurrentUser;
@property (nonatomic) NSMutableDictionary *valid_user_info;

-(void)gatherFormInfo;

@property (nonatomic) BOOL successful_login;
@property (nonatomic) BOOL does_exist;
@property (nonatomic) BOOL valid_email;
@property (nonatomic) BOOL valid_password;

@property (nonatomic) bool is_filled;

@property (retain, nonatomic) NSData *receivedData;


@end
