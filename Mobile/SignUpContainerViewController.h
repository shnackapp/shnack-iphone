//
//  SignUpContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/14/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpNavController.h"

@interface SignUpContainerViewController : UITableViewController <UITextFieldDelegate,NSURLConnectionDelegate>


@property (retain, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *passwordLabel;

@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic) NSString  *temp_phone;


@property (retain, nonatomic) NSData *receivedData;
@property (retain, nonatomic) NSMutableData *responseData;



-(BOOL)checkForContent:(UITextField *)theTextField;
-(void)presentErrors;

-(void)gatherFormInfo;

-(BOOL)isValidEmail:(NSString *)email;
-(BOOL)isValidPhone:(NSString *)phone;
-(BOOL)isValidPassword:(NSString *)password;
-(BOOL)textField:(UITextField *) textField;


@property (nonatomic) bool valid_email;
@property (nonatomic) bool valid_phone;
@property (nonatomic) bool valid_password;
@property (nonatomic) bool is_valid;
@property (nonatomic) bool is_filled;









@end
