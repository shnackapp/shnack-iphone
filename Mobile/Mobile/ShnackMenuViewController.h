//
//  ShnackMenuViewController2.h
//  Mobile
//
//  Created by Jake Staahl on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "POPDTableView.h"
#import "BButton.h"
#import "Item.h"

@interface ShnackMenuViewController : UIViewController <UITableViewDelegate, UIGestureRecognizerDelegate>
extern NSMutableArray *globalArrayLocations;
extern NSMutableArray *globalArrayModifiers;
extern NSIndexPath *selectedLocationIndexPath;
extern NSIndexPath *selectedItemIndexPath;

extern NSMutableArray *globalArrayOrderItems;
extern NSMutableArray *globalOpenOrderMenu;
extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern Item *globalCurrentItem;
extern UIPageViewController *mainPages;
extern NSMutableDictionary *global_menu;
extern NSMutableArray *global_item_menu;


@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet POPDTableView *tableView;
@property (weak, nonatomic) IBOutlet BButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UILabel *vendorName;
@property (nonatomic) BOOL isCartShowing;

@property (nonatomic,retain) NSMutableArray *modifiers;
@property (nonatomic,retain) NSMutableArray *options;

@end
