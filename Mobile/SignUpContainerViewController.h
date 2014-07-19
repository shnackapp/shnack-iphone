//
//  SignUpContainerViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/14/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpContainerViewController : UITableViewController <UITextFieldDelegate>


@property (retain, nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UILabel *emailLabel;

@property (retain, nonatomic) IBOutlet UITextField *password;
@property (nonatomic) IBOutlet UILabel *passwordLabel;

@property (retain, nonatomic) IBOutlet UITextField *phone;
@property (nonatomic) IBOutlet UILabel *phoneLabel;




@end
