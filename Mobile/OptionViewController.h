//
//  OptionViewController.h
//  Shnack
//
//  Created by Spencer Neste on 10/12/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "Item.h"

@interface OptionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableArray *modifiers;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *options;

extern NSMutableArray *globalArrayLocations;
extern NSIndexPath *selectedModifierIndexPath;
extern NSMutableArray *globalOpenOrderMenu;

extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern Item *globalCurrentItem;
extern NSString *globalCurrentModifier;

extern UIPageViewController *mainPages;
extern NSMutableDictionary *global_menu;
extern NSMutableArray *global_item_menu;


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet BButton *apply_button;



@end
