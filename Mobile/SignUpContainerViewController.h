//
//  SignUpContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/14/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpContainerViewController : UITableViewController <UITextFieldDelegate>


@property (retain, nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UILabel *nameLabel;

@property (retain, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *passwordLabel;

@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (nonatomic) IBOutlet UILabel *phoneLabel;

-(void)createUserWithInfo:(NSString *)name andEmail:(NSString *)email andPhone:(NSString *)phone andPassword:(NSString *)password;

extern NSMutableArray *globalUserInfo;

-(IBAction)submit:(UIButton *)sender;

-(BOOL)isValidName:(NSString *)name;
-(BOOL)isValidEmail:(NSString *)email;
-(BOOL)isValidPhone:(NSString *)phone;
-(BOOL)isValidPassword:(NSString *)password;
-(BOOL)textField:(UITextField *) textField;

@property (nonatomic) bool valid_name;
@property (nonatomic) bool valid_email;
@property (nonatomic) bool valid_phone;
@property (nonatomic) bool valid_password;







@end
