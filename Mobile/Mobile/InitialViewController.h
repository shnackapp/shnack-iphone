//
//  InitialViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/8/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialContentViewController.h"


@interface InitialViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *pageTitles;

@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *TopTitles;

@property (strong, nonatomic) NSArray *swipe;
@property (strong, nonatomic) NSArray *swipeLogo;
@property (strong, nonatomic) NSArray *swipeBlurb;

@property UIPageControl *dots;

@property bool did_skip_initial;




@property (strong, nonatomic) IBOutlet UIButton *signUp;
@property (strong, nonatomic) IBOutlet UIButton *orderNow;
@property (strong, nonatomic) IBOutlet UIButton *Login;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;





@end

