//
//  ShnackMenuViewController.h
//  shnack-shnack
//
//  Created by Anshul Jain on 2/22/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShnackMenuViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *menu;

-(IBAction)increaseCountByOne:(id)sender;
-(IBAction)decreaseCountByOne:(id)sender;
-(int)calculateOrderTotal;

@end