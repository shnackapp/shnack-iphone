//
//  SignUpViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>



@interface SignUpViewController : UIViewController<NSURLConnectionDelegate>

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UILabel *signUpTitle;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

-(IBAction)next;

@property (weak, nonatomic) IBOutlet UIView *container;

@property (retain, nonatomic) NSData *receivedData;
@property (retain, nonatomic) NSMutableData *responseData;
@property NSMutableDictionary *text_fields;



@property (nonatomic) bool valid_email;
@property (nonatomic) bool valid_phone;
@property (nonatomic) bool valid_password;
@property (nonatomic) NSString *temp_phone;



















@end
