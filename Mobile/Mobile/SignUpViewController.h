//
//  SignUpViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UILabel *signUpTitle;

@property (nonatomic) IBOutlet UITextView *error_messages;
-(IBAction)next;


@property (weak, nonatomic) IBOutlet UIView *container;



















@end
