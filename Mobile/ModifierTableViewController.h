//
//  ModifierTableViewController.h
//  Shnack
//
//  Created by Spencer Neste on 10/1/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifierTableViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *menu;

extern NSMutableArray *globalArrayLocations;
extern NSIndexPath *selectedIndexPath;
extern NSMutableArray *globalOpenOrderMenu;
extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern UIPageViewController *mainPages;


@end
