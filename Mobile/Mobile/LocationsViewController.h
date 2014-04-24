//
//  MasterViewController.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPDTableViewController.h"

//#import <CoreData/CoreData.h>

@interface LocationsViewController  : POPDTableViewController < UITableViewDataSource >
//
//not used but keep for now
extern NSMutableArray *globalArrayLocations;
extern NSIndexPath *selectedIndexPath;
extern NSString *globalCurrentVendorName;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//////////

//@property (strong, nonatomic) UITableView *mytableView;

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, retain) NSMutableData *responseData;

//@property (retain, nonatomic) NSData *registerDeviceResponse;
//-(IBAction)registerDevice:(id)sender;
@end
