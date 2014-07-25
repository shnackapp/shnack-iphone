//
//  SignUpViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

<<<<<<< HEAD
@interface SignUpViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UILabel *signUpTitle;

@property (nonatomic) IBOutlet UITextView *error_messages;
-(IBAction)next;

@property (nonatomic) IBOutlet UILabel *error_1;
@property (nonatomic) IBOutlet UILabel *error_2;
@property (nonatomic) IBOutlet UILabel *error_3;
@property (nonatomic) IBOutlet UILabel *error_title;







=======
@interface SignUpViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *passwordLabel;

@property (retain, nonatomic) IBOutlet UITextField *passwordConfirm;
@property (nonatomic) IBOutlet UILabel *passwordConfirmLabel;

@property (retain, nonatomic) IBOutlet UIButton *startOrdering;

@property (nonatomic) BOOL validEmail;
@property (nonatomic) BOOL passwordMatch;

@property (nonatomic) IBOutlet UILabel *passwordMismatch;
@property (nonatomic) IBOutlet UILabel *invalidEmail;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a












@end
