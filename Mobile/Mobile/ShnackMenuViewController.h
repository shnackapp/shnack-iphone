//
//  ShnackMenuViewController.h
//  shnack-shnack
//
//  Created by Anshul Jain on 2/22/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShnackMenuViewController : UITableViewController
extern NSMutableArray *globalArrayVendor;
extern NSInteger selectedStadiumRow, selectedVendorRow;

@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableData *responseData;


-(IBAction)increaseCountByOne:(id)sender;
-(IBAction)decreaseCountByOne:(id)sender;
-(int)calculateOrderTotal;

@end
