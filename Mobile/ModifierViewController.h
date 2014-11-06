//
//  ModifierViewController.h
//  Shnack
//
//  Created by Spencer Neste on 10/6/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "Item.h"
#import "Modifier.h"
#import "Option.h"
#import "Order.h"

@interface ModifierViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableArray *modifiers;
@property (nonatomic, retain) NSMutableArray *items;
//@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, retain) NSMutableArray *multi_options;



extern NSMutableArray *globalArrayLocations;
extern NSMutableArray *globalArrayModifiers;
extern NSMutableArray *globalArrayOrderItems;

extern NSIndexPath *selectedItemIndexPath;
extern NSIndexPath *selectedModIndexPath;

-(void) refreshTableToSetDetailText:(NSMutableArray*) option_label andPrice:(NSMutableArray*)price_or_prices andIndex: (NSIndexPath *)index;

@property (nonatomic,retain) NSMutableArray *option_prices;
@property (nonatomic,retain) NSMutableArray *option_names;

extern NSMutableArray *globalOpenOrderMenu;
extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern Modifier *globalCurrentModifier;
extern Item *globalCurrentItem;
extern Option *globalCurrentOption;

@property(nonatomic) Item *order_item;

extern UIPageViewController *mainPages;
extern NSMutableDictionary *global_menu;
extern NSMutableArray *global_item_menu;


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet BButton *add_to_cart_button;


@end
