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

@property (nonatomic) bool valid_first;
@property (nonatomic) bool valid_last;
-(void)gatherInfo;
@property (nonatomic) bool is_filled;

@end
