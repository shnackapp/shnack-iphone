//
//  ShnackMenuViewController2.m
//  Mobile
//
//  Created by Jake Staahl on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ShnackMenuViewController.h"
#import "Item.h"
#import "ShnackOrderItemCell.h"
#import "ShnackOrderTotalCell.h"
#import "ObjectWithNameAndID.h"
#import "RESideMenu.h"
#import "POPDCell.h"
#import "ShnackOrderCategoryCell.h"
<<<<<<< HEAD
#import "NSObject_Constants.h"
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

@interface ShnackMenuViewController ()  <POPDDelegate>
@property (nonatomic) NSInteger vendorID;
@end
NSInteger myCount;

@implementation ShnackMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //self.tableView.delegate = self;
    self.tableView.popDownDelegate = self;
    //self.tableView.dataSource = self;
    
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
    [self.checkoutButton setStyle:BButtonStyleBootstrapV3];
    [self.checkoutButton setType:BButtonTypeDanger];
<<<<<<< HEAD
}

-(void)viewDidAppear:(BOOL)animated {
    if (selectedIndexPath == nil) {
        self.checkoutButton.enabled = NO;
    } else {
        self.checkoutButton.enabled = YES;
        
        globalCurrentVendorID = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] object_id];
        globalCurrentVendorName = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] name];
        self.vendorName.text = globalCurrentVendorName;
        

        if (globalCurrentVendorID != globalOpenOrderVendorID) {
            self.responseData = [NSMutableData data];
            NSString *url = [NSString stringWithFormat:@"%@/get_menu_for_vendor?object_id=%d", BASE_URL,globalCurrentVendorID];
            NSString *api_key = [NSString stringWithFormat:API_KEY];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            [request setValue:api_key forHTTPHeaderField:@"Authorization"];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        } else {
            self.menu = globalOpenOrderMenu;
            NSMutableArray *tableData = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < [self.menu count]; i++)
            {
                NSArray *category = self.menu[i];
                Item *categoryItem = category[0];
                NSString *categoryName = categoryItem.name;
                NSMutableArray *tableSection = [[NSMutableArray alloc] init];
                for (NSInteger j = 1; j < [category count]; j++)
                {
                    Item *item = category[j];
                    [tableSection addObject:item.name];
                }
                NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:categoryName,POPDCategoryTitleTV,tableSection, POPDSubSectionTV,nil];
                [tableData addObject:section];
            }
            [self.tableView setMenuSections:tableData];
            NSLog(@"11111111111");

        }
        
        NSInteger total = [self calculateOrderTotal];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    }
    
    
    NSLog(@"2222222222");

=======
    
    self.vendorID = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] object_id];
    self.responseData = [NSMutableData data];
    NSString *url = [NSString stringWithFormat:@"http://nvc.shnackapp.com/api/get_menu_for_vendor?object_id=%d",
                     self.vendorID];
    NSString *api_key = [NSString stringWithFormat:@"Token token=\"d157b1e177b7ba1e4547a0d6e11aa627\""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:api_key forHTTPHeaderField:@"Authorization"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [self.tableView reloadData];
        NSInteger total = [self calculateOrderTotal];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    
    NSLog(@"555555555");

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    NSError *myError = nil;
    
<<<<<<< HEAD
    NSLog(@"33333333");

=======
    
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"my JSON: %@",res);
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:[res count]];
    self.menu = [[NSMutableArray alloc] initWithCapacity:[res count]];
    for(NSDictionary *category in res) {
        NSArray *items = [category objectForKey:@"items"];
        NSString *categoryName = [category objectForKey:@"name"];
        NSMutableArray *menuCategory = [[NSMutableArray alloc] initWithCapacity:[items count]];
        NSMutableArray *tableSection = [[NSMutableArray alloc] initWithCapacity:[items count]];
<<<<<<< HEAD
        Item *categoryItem = [[Item alloc] initWithName:categoryName andCount:0];
        [menuCategory addObject:categoryItem];
=======
        [menuCategory addObject:categoryName];
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
        for(NSDictionary *item in items)
        {
            NSInteger price = [[item objectForKey:@"price"] integerValue];
            NSString *name = [item valueForKey:@"name"];
            Item *item = [[Item alloc] initWithName:name andPrice:price];
            NSLog(@"\nMenu : %@", self.menu);
            [menuCategory addObject:item];
            [tableSection addObject:name];
        }
<<<<<<< HEAD
        
        NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:
                       categoryName, POPDCategoryTitleTV,
                       tableSection, POPDSubSectionTV,
=======
        myCount = [self.menu count];
        for (NSInteger i=0; i<myCount;i++)
        {
            //NSLog(@"\nMenu : %@", [self.menu[i] name]);
        }
        
        
        
        NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:
                       categoryName, POPDCategoryTitle,
                       tableSection, POPDSubSection,
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
                       nil];

        [tableData addObject:section];
        [self.menu addObject:menuCategory];
    }
    
    
<<<<<<< HEAD

=======
    
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    
    [self.tableView setMenuSections:tableData];
    [self.tableView reloadData];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void) willDisplayLeafSubCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
<<<<<<< HEAD
=======
    // Configure the cell...
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    ShnackOrderItemCell *itemCell = (ShnackOrderItemCell *)cell;
    Item *item = self.menu[indexPath.section][indexPath.row];
    
    itemCell.name.text = item.name;
    itemCell.price.text = [NSString stringWithFormat:@"$%d.%02d", item.price/100, item.price%100];
    itemCell.count.text = [NSString stringWithFormat:@"%d", item.count];
    
    [itemCell.plusButton addTarget:self action:@selector(increaseCountByOne:) forControlEvents:UIControlEventTouchDown];
    [itemCell.minusButton addTarget:self action:@selector(decreaseCountByOne:) forControlEvents:UIControlEventTouchDown];
<<<<<<< HEAD
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
}

-(void) willDisplayClosedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayOpenedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
<<<<<<< HEAD
    NSInteger categoryCount = ((Item *)self.menu[indexPath.section][0]).count;
=======
    NSInteger categoryCount = [self calculateCategoryCount:indexPath.section];
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    ShnackOrderCategoryCell *categoryCell = (ShnackOrderCategoryCell *)cell;
    if (categoryCount == 0) {
        categoryCell.count.hidden = YES;
    } else {
        categoryCell.count.hidden = NO;
        categoryCell.count.text = [NSString stringWithFormat:@"%ld", (long)categoryCount];
    }
<<<<<<< HEAD
    categoryCell.labelText.text = ((Item *)self.menu[indexPath.section][0]).name;
=======
    categoryCell.labelText.text = self.menu[indexPath.section][0];
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
}


-(NSInteger)calculateOrderTotal
{
    NSInteger total = 0;
    for (NSArray *category in self.menu) {
        for (NSInteger i = 1; i < [category count]; i++) {
            total += ((Item *)category[i]).price * ((Item *)category[i]).count;
        }
    }
    
    return total;
}

<<<<<<< HEAD
=======
-(NSInteger)calculateCategoryCount:(NSInteger)section {
    NSInteger count = 0;
    NSInteger numItems = [((NSArray *)self.menu[section]) count];
    for (NSInteger i = 1; i < numItems; i++) {
        count += ((Item *)self.menu[section][i]).count;
    }
    return count;
}
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

-(IBAction)increaseCountByOne:(id)sender
{
    if (globalOpenOrderMenu != self.menu) {
        globalOpenOrderMenu = self.menu;
<<<<<<< HEAD
        globalOpenOrderVendorID = globalCurrentVendorID;
        globalOpenOrderVendorName = globalCurrentVendorName;
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    Item *categoryItem = self.menu[indexPath.section][0];
=======
    }
    if (globalOpenOrderVendorID != self.vendorID) {
        globalOpenOrder = [[NSMutableDictionary alloc] init];
    }
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    Item *item = self.menu[indexPath.section][indexPath.row];
    item.count++;
    categoryItem.count++;
    
<<<<<<< HEAD
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
=======
    NSNumber *sectionNumber = [NSNumber numberWithInt:indexPath.section];
    NSMutableDictionary *openOrderSection = [globalOpenOrder objectForKey:sectionNumber];
    if (openOrderSection == nil) {
        openOrderSection = [[NSMutableDictionary alloc] init];
        [globalOpenOrder setObject:openOrderSection forKey:sectionNumber];
    }
    NSNumber *sectionRow = [NSNumber numberWithInt:indexPath.row];
    [globalOpenOrder setObject:item forKey:sectionRow];
    
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%ld.%02ld", total/100, total%100];
    
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(IBAction)decreaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
<<<<<<< HEAD
    Item *categoryItem = self.menu[indexPath.section][0];
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    Item *item = self.menu[indexPath.section][indexPath.row];
    if(item.count > 0)
    {
        categoryItem.count--;
        item.count--;
    }
    
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
<<<<<<< HEAD



=======

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

@end
