//
//  DetailViewController.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorViewController :  UITableViewController <  UITableViewDelegate, UITableViewDataSource >

@property (strong, nonatomic) id vendorItem;
@property (weak, nonatomic) IBOutlet UILabel *vendorDescriptionLabel;

@property (nonatomic, strong) NSMutableArray *vendors;
@property (nonatomic, retain) NSMutableData *responseData;

@end
