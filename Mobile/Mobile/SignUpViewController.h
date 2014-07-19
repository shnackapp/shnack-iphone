//
//  SignUpViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>


@property (retain, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *passwordLabel;

@property (retain, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (nonatomic) IBOutlet UILabel *passwordConfirmLabel;

@property (retain, nonatomic) IBOutlet UIButton *startOrdering;

@property (nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic) BOOL validEmail;
@property (nonatomic) BOOL passwordMatch;



@property (nonatomic) IBOutlet UILabel *passwordMismatch;
@property (nonatomic) IBOutlet UIImageView *passwordMatchCheck;
@property (nonatomic) IBOutlet UIImageView *passwordConfirmCheck;

@property (nonatomic) IBOutlet UILabel *invalidEmail;
@property (nonatomic) IBOutlet UIImageView *validEmailCheck;













@end
