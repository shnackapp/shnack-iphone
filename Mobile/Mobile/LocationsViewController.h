//
//  MasterViewController.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPDTableViewController.h"
#import "MainPageViewController.h"

//#import <CoreData/CoreData.h>

@interface LocationsViewController  : POPDTableViewController < UITableViewDataSource >
//

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

extern NSMutableArray *globalArrayLocations;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, strong) NSMutableArray *locations;


@property (nonatomic, retain) NSMutableData *responseData;
extern NSIndexPath *selectedIndexPath;
extern NSString *globalCurrentVendorName;
extern MainPageViewController *mainPages;


@end
