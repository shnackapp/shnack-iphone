//
//  ShnackMyOrderViewController.h
//  Mobile
//
//  Created by Jake Staahl on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "POPDTableViewController.h"
#import "POPDTableView.h"
#import "BButton.h"

@interface ShnackMyOrderViewController : UIViewController  <POPDDelegate>
extern NSMutableArray *globalOpenOrderMenu;
extern NSMutableArray *globalOpenOrder;
extern NSInteger globalOpenOrderVendorID;
extern NSInteger globalCurrentVendorID;
extern NSString *globalOpenOrderVendorName;
extern NSString *globalCurrentVendorName;
extern int *globalCurrentOrderAmount;

@property (strong, nonatomic) IBOutlet POPDTableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *vendorName;
@property (weak, nonatomic) IBOutlet BButton *checkoutButton;


@end
