//
//  ShnackMenuViewController2.h
//  Mobile
//
//  Created by Jake Staahl on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "POPDTableView.h"
#import "BButton.h"

@interface ShnackMenuViewController : UIViewController
extern NSMutableArray *globalArrayLocations;
extern NSIndexPath *selectedIndexPath;
extern NSMutableArray *globalOpenOrderMenu;
extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern UIPageViewController *mainPages;

@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet POPDTableView *tableView;
@property (weak, nonatomic) IBOutlet BButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UILabel *vendorName;


-(IBAction)increaseCountByOne:(id)sender;
-(IBAction)decreaseCountByOne:(id)sender;
-(int)calculateOrderTotal;

@end
