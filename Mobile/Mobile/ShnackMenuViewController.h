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
<<<<<<< HEAD
extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern UIPageViewController *mainPages;
=======
extern NSMutableDictionary *globalOpenOrder;
extern NSInteger globalOpenOrderVendorID;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet POPDTableView *tableView;
@property (weak, nonatomic) IBOutlet BButton *checkoutButton;
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UILabel *vendorName;
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a


-(IBAction)increaseCountByOne:(id)sender;
-(IBAction)decreaseCountByOne:(id)sender;
-(int)calculateOrderTotal;

@end
