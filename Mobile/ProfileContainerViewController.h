//
//  ProfileContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileContainerViewController : UITableViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *first;
@property (nonatomic) IBOutlet UILabel *firstLabel;

@property (retain, nonatomic) IBOutlet UITextField *last;
@property (nonatomic) IBOutlet UILabel *lastLabel;

-(BOOL)isValidFirst:(NSString *)first;
-(BOOL)isValidLast:(NSString *)last;

@property (nonatomic) bool valid_first;
@property (nonatomic) bool valid_last;
@property (nonatomic) bool is_valid;

- (BOOL) isAlphaNumeric;
-(void) gatherInfo;

-(BOOL)textFieldHelper:(UITextField *)theTextField;


@end
