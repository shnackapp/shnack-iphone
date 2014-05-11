//
//  MainPageViewController.h
//  Mobile
//
//  Created by Spencer Neste on 5/10/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIPageViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) NSArray *pages;
@property (strong, nonatomic) NSMutableDictionary *pageIndices;
extern MainPageViewController *mainPages;

-(UIViewController *) nextViewController;


@end
