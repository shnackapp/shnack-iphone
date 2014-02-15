//
//  MasterViewController.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface StadiumViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//IBOutlet UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray *stadia;

@property (strong, nonatomic) IBOutlet UIPickerView *stadiumPicker;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (retain, nonatomic) NSData *registerDeviceResponse;

-(IBAction)registerDevice:(id)sender;
@end
