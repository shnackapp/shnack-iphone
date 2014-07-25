//
//  MasterViewController.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPDTableViewController.h"
<<<<<<< HEAD
#import "MainPageViewController.h"
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

//#import <CoreData/CoreData.h>

@interface LocationsViewController  : POPDTableViewController < UITableViewDataSource >
//
<<<<<<< HEAD
extern NSMutableArray *globalArrayLocations;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, strong) NSMutableArray *locations;


@property (nonatomic, retain) NSMutableData *responseData;
extern NSIndexPath *selectedIndexPath;
extern NSString *globalCurrentVendorName;
extern MainPageViewController *mainPages;


=======
//not used but keep for now
extern NSMutableArray *globalArrayLocations;
extern NSInteger selectedIndexPath;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//////////

//@property (strong, nonatomic) UITableView *mytableView;

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, retain) NSMutableData *responseData;

//@property (retain, nonatomic) NSData *registerDeviceResponse;
//-(IBAction)registerDevice:(id)sender;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
@end
