//
//  CartPopViewController.h
//  Mobile
//
//  Created by Spencer Neste on 8/9/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"
#import "OpenOrderTableViewCell.h"

@interface CartPopViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet BButton *closeCart;
@property (nonatomic) IBOutlet BButton *checkoutButton;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UILabel *cart;


-(IBAction)checkout;
@property (nonatomic) NSInteger order_total;

extern NSMutableArray *globalArrayOrderItems;





@end
