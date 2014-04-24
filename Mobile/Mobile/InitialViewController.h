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


@end

