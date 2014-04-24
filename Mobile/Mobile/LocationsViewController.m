//
//  StadiumViewController.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LocationsViewController.h"
#import "ObjectWithNameAndID.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "POPDCell.h"

@interface LocationsViewController () <POPDDelegate>
@end

@implementation LocationsViewController

NSIndexPath *reloadingCategoryIndexPath;

//NSMutableArray * myArray;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//
//
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}
- (void)viewDidLoad
{
    self.delegate = self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
    //NSLog(@"viewdidload");//
    self.responseData = [NSMutableData data];//
    //NSLog(@"response data is %@",self.responseData);
    
    //[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[UIView new]]];
    //[self.navigationItem setLeftBarButtonItem:nil];
    self.navigationItem.hidesBackButton = YES;
    
    NSString *url = [NSString stringWithFormat:@"http://nvc.shnackapp.com/api/get_locations"];
    NSString *api_key = [NSString stringWithFormat:@"Token token=\"d157b1e177b7ba1e4547a0d6e11aa627\""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
    [request setHTTPMethod:@"GET"];
    
    [request setValue:api_key forHTTPHeaderField:@"Authorization"];
    
    [self setLoading:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];//
    
    //[_mytableView registerClass: [StadiumCell class] forCellReuseIdentifier:@"StadiumCell"];
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
}
//////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"didReceiveData");
    [self.responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   // NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *url = [[[connection currentRequest] URL] lastPathComponent];
    NSError *myError = nil;
    
    
    if ([url compare:@"get_locations"] == NSOrderedSame) {
        NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        self.locations = [[NSMutableArray alloc] initWithCapacity:[res count]];
        
        
        NSLog(@"%@", [res description]);
        
        NSMutableArray *menu = [[NSMutableArray alloc] initWithCapacity:[res count]];
        for(NSDictionary *stadium in res)
        {
            int id_ = [[stadium objectForKey:@"id"] integerValue];
            NSString *name = [stadium valueForKey:@"name"];
            BOOL hasChildren = [[stadium valueForKey:@"has_children"] boolValue];
            
            ObjectWithNameAndID *aStadium = [[ObjectWithNameAndID alloc] initWithID:id_ name:name];
            
            NSDictionary *section;
            if (hasChildren) {
                section = [NSDictionary dictionaryWithObjectsAndKeys:
                                    name, POPDCategoryTitle,
                                    [[NSArray alloc] init], POPDSubSection,
                                    nil];
                [self.locations addObject:aStadium];
            } else {
                section = [NSDictionary dictionaryWithObjectsAndKeys:
                                        name, POPDCategoryTitle,
                                        nil, POPDSubSection,
                                        nil];
                [self.locations addObject: [NSArray arrayWithObjects:aStadium,nil]];
            }
            [menu addObject:section];
        }
        
        globalArrayLocations = self.locations;
        [self setMenuSections:menu];
        [self setLoading:NO];
    }
    else {
        NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        NSMutableArray *vendors = [[NSMutableArray alloc] initWithCapacity:[res count]];
        [vendors addObject:[self.locations objectAtIndex:reloadingCategoryIndexPath.section]];
        
        NSLog(@"%@", [res description]);
        
        NSMutableArray *sectionChildren = [[NSMutableArray alloc] initWithCapacity:[res count]+1];
        for(NSDictionary *stadium in res)
        {
            int id_ = [[stadium objectForKey:@"id"] integerValue];
            NSString *name = [stadium valueForKey:@"name"];
            
            ObjectWithNameAndID *aStadium = [[ObjectWithNameAndID alloc] initWithID:id_ name:name];
            [vendors addObject: aStadium];

            [sectionChildren addObject:name];
        }
        [self.locations replaceObjectAtIndex:reloadingCategoryIndexPath.section withObject:vendors];

        [self setMenuSectionChildren:sectionChildren atSection:reloadingCategoryIndexPath.section];

        POPDCell *cell = (POPDCell *)[self.tableView cellForRowAtIndexPath:reloadingCategoryIndexPath];
        [cell.indicator stopAnimating];
    }
}


- (void)viewDidUnload {

    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View

- (void)didSelectCategoryRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------->row selected %ld", (long)indexPath.row);
    
    if (![[self.locations objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
        reloadingCategoryIndexPath = indexPath;
        
        POPDCell *cell = (POPDCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.indicator startAnimating];
        
        NSString *url =
        [NSString stringWithFormat:@"http://nvc.shnackapp.com/api/get_vendor_for_location?object_id=%d",[globalArrayLocations[indexPath.section] object_id]];
        NSString *api_key = [NSString stringWithFormat:@"Token token=\"d157b1e177b7ba1e4547a0d6e11aa627\""];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
        [request setHTTPMethod:@"GET"];
        [request setValue:api_key forHTTPHeaderField:@"Authorization"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        //selectedStadiumRow = indexPath.row;
    }
}

- (void)didSelectLeafRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECTED LEAF ROW!@@!!");
    selectedIndexPath = indexPath;
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showVendor"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//        [[segue destinationViewController] setVendorItem:object];
//    }
//}

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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}

@end
