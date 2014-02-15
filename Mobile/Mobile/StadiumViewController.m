//
//  StadiumViewController.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "StadiumViewController.h"
#import "ObjectWithNameAndID.h"
#import "VendorViewController.h"
#import "StadiumCell.h"



@interface StadiumViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation StadiumViewController
@synthesize responseData = _responseData;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidload");//
    self.responseData = [NSMutableData data];//
    
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:3000/api/index"];
    NSString *api_key = [NSString stringWithFormat:@"Token token=\"b2c70bb5d8d2bb35b6b4fcfbc9043d6a\""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
    [request setHTTPMethod:@"GET"];
    
    [request setValue:api_key forHTTPHeaderField:@"Authorization"];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];//
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

   // UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
}
//////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    [self.responseData appendData:data];
    //NSLog(@"data: %@", self.responseData);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    NSError *myError = nil;
    
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    self.stadia = [[NSMutableArray alloc] initWithCapacity:[res count]];
    
    for(NSDictionary *stadium in res)
    {
        int id_ = [[stadium objectForKey:@"id"] integerValue];
        NSString *name = [stadium valueForKey:@"name"];
        ObjectWithNameAndID *aStadium=[ObjectWithNameAndID   alloc];
        aStadium.object_id=id_;
        aStadium.name=name;
       // NSLog(@"id is %d", aStadium.object_id);
       // NSLog(@"name is %@", aStadium.name);

        NSLog(@"adding %d and %@ to stadia array", aStadium.object_id,aStadium.name);
        [self.stadia addObject: aStadium];
        NSLog(@"aStadium instance %@", aStadium);

        NSLog(@"stadia array contains %@", self.stadia[0]);
    }
   // NSLog(@"what's in self.stadia: %@",[self.stadia objectAtIndex:0]);

       // NSLog(@"name is %@", self.stadia);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
         // Replace this implementation with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@" number of rows is %@",self.stadia);
    return [self.stadia count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StadiumCell";

//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//    }
//    
//    cell.textLabel.text = [self.stadia[0] objectAtIndex:[indexPath row]];
//    NSLog(@"Cell is %@", [self.stadia[0] objectAtIndex:indexPath.row]);
//    return cell;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StadiumCell" forIndexPath:indexPath];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//	cell.textLabel.text = [[self.stadia objectAtIndex:indexPath.row] objectForKey:@"id"];
//    cell.detailTextLabel.text = [[self.stadia objectAtIndex:indexPath.row] objectForKey:@"name"];

    
    StadiumCell *cell = (StadiumCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.stadiumName.text = [self.stadia[0] name];
    
    
    return cell;

}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return NO;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        NSError *error = nil;
//        if (![context save:&error]) {
//             // Replace this implementation with code to handle the error appropriately.
//             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }   
//}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // The table view should not be re-orderable.
//    return NO;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showVendor"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setVendorItem:object];
    }
}

#pragma mark - Fetched results controller
//
//- (NSFetchedResultsController *)fetchedResultsController
//{
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    // Edit the entity name as appropriate.
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
//    
//    // Edit the sort key as appropriate.
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
//    NSArray *sortDescriptors = @[sortDescriptor];
//    
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    
//    // Edit the section name key path and cache name if appropriate.
//    // nil for section name key path means "no sections".
//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Stadium"];
//    aFetchedResultsController.delegate = self;
//    self.fetchedResultsController = aFetchedResultsController;
//    
//	NSError *error = nil;
//	if (![self.fetchedResultsController performFetch:&error]) {
//	     // Replace this implementation with code to handle the error appropriately.
//	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//	    abort();
//	}
//    
//    return _fetchedResultsController;
//}    
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.tableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath
//{
//    UITableView *tableView = self.tableView;
//    
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.tableView endUpdates];
//}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
//}

@end
