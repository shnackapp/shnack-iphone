//
//  PaymentContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentContainerViewController : UITableViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *card_no;

@property (retain, nonatomic) IBOutlet UITextField *expire_date;

@property (retain, nonatomic) IBOutlet UITextField *cvv;

@property (nonatomic) bool valid_card;
@property (nonatomic) bool valid_date;
@property (nonatomic) bool valid_cvv;

@property (nonatomic) bool is_valid;


-(BOOL) isValidCard:(NSString *) card;
-(BOOL) isValidDate:(NSString *) date;
-(BOOL) isValidCvv:(NSString *) code;


-(void) gatherInfo;

-(BOOL)textFieldHelper:(UITextField *)theTextField;

-(void)createUserWithInfo:(NSString *)name andEmail:(NSString *)email andPhone:(NSString *)phone andPassword:(NSString *)password;

@end
