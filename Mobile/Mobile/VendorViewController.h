//
//  DetailViewController.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StadiumViewController.h"
#import "RESideMenu.h"

@interface VendorViewController :  UITableViewController <  UITableViewDelegate, UITableViewDataSource >

extern NSMutableArray *globalArrayStadia,*globalArrayVendor;
extern NSInteger selectedStadiumRow, selectedVendorRow;
@property (strong, nonatomic) id vendorItem;
@property ( nonatomic) int stadium_id;



@property (weak, nonatomic) IBOutlet UILabel *vendorDescriptionLabel;

@property (nonatomic, strong) NSMutableArray *vendors;
@property (nonatomic, retain) NSMutableData *responseData;

@end

