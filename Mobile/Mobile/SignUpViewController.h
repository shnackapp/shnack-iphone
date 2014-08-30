//
//  SignUpViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface SignUpViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UILabel *signUpTitle;

@property (nonatomic) IBOutlet UITextView *error_messages;
-(IBAction)next;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;


@property (weak, nonatomic) IBOutlet UIView *container;



















@end
