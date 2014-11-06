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
#import "Modifier.h"
#import "Option.h"

@interface OptionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableArray *modifiers;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *options;

@property (nonatomic, retain) NSMutableArray *option_name_for_mod;
@property(nonatomic,retain) NSMutableArray *option_price_for_mod;

@property (nonatomic, retain) NSMutableArray *single_option_name_for_mod;
@property(nonatomic,retain) NSMutableArray *single_option_price_for_mod;

@property (nonatomic) BOOL DEFAULT_OPTION;
@property (nonatomic,retain) NSMutableArray *default_option_price;
@property (nonatomic,retain) NSMutableArray *default_option_name;

extern NSMutableArray *globalArrayLocations;
extern NSIndexPath *selectedModIndexPath;
extern NSInteger selectedOptionIndexPathRow;
extern NSMutableArray *globalOpenOrderMenu;

extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern Item *globalCurrentItem;
extern Modifier *globalCurrentModifier;
extern Option *globalCurrentOption;

extern UIPageViewController *mainPages;
extern NSMutableDictionary *global_menu;
extern NSMutableArray *global_item_menu;


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet BButton *apply_button;



@end
