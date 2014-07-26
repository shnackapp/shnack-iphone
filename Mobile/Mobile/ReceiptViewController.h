//
//  ReceiptViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/25/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *subtotal;
@end
