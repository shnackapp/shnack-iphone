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
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a


@property NSUInteger pageIndex;
@property NSString *blurbText;
@property NSString *imageFile;
@property NSString *TopText;
<<<<<<< HEAD
@property NSString *swipeLabelText;
@property NSString *brandLabelText;



=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a


@end
