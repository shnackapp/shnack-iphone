//
//  SignUpProfileViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpProfileViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UILabel *signUpTitle;

-(IBAction)next;

@property (weak, nonatomic) IBOutlet UIView *container;

@end
