//
//  LoginContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 5/28/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginContainerViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) IBOutlet UILabel *loginTitle;
@property (nonatomic) IBOutlet UIButton *forgotPassword;
extern NSMutableArray *globalCurrentUser;
@property (retain, nonatomic) NSData *receivedData;

@property (nonatomic) BOOL successful_login;
@property (nonatomic) BOOL does_exist;

-(IBAction)home;//this fixes keyboard issue on clear
-(IBAction)submit;
-(BOOL)login;










@end
