//
//  TutorialContentViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/7/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *supposedbackgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *blurbLabel;
@property (weak, nonatomic) IBOutlet UILabel *TopLabel;


@property NSUInteger pageIndex;
@property NSString *blurbText;
@property NSString *imageFile;
@property NSString *TopText;


@end
