//
//  CartPopViewController.h
//  Mobile
//
//  Created by Spencer Neste on 8/9/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"

@interface CartPopViewController : UIViewController

@property (nonatomic) IBOutlet BButton *closeCart;
@property (nonatomic) IBOutlet BButton *checkoutButton;
@property (nonatomic) IBOutlet UITableView *cartView;
@property (nonatomic) IBOutlet UILabel *cart;

-(IBAction)checkout;





@end
