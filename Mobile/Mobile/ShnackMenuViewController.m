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

@interface ShnackMenuViewController ()  <POPDDelegate>

@end

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
    
    if (selectedIndexPath == nil) {
        self.checkoutButton.enabled = NO;
    } else {
        self.checkoutButton.enabled = YES;
    
        globalCurrentVendorID = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] object_id];
        globalCurrentVendorName = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] name];
        self.vendorName.text = globalCurrentVendorName;
        
        if (globalCurrentVendorID != globalOpenOrderVendorID) {
            self.responseData = [NSMutableData data];
            NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:3000/api/get_menu_for_vendor?object_id=%d", globalCurrentVendorID];
            NSString *api_key = [NSString stringWithFormat:@"Token token=\"b2c70bb5d8d2bb35b6b4fcfbc9043d6a\""];
    
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            
            [request setValue:api_key forHTTPHeaderField:@"Authorization"];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
        } else {
            self.menu = globalOpenOrderMenu;
            NSMutableArray *tableData = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < [self.menu count]; i++) {
                NSArray *category = self.menu[i];
                Item *categoryItem = category[0];
                NSString *categoryName = categoryItem.name;
                NSMutableArray *tableSection = [[NSMutableArray alloc] init];
                for (NSInteger j = 1; j < [category count]; j++) {
                    Item *item = category[j];
                    [tableSection addObject:item.name];
                }
                NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:
                                         categoryName, POPDCategoryTitle,
                                         tableSection, POPDSubSection,
                                         nil];
                [tableData addObject:section];
            }
            [self.tableView setMenuSections:tableData];

        }
        NSInteger total = [self calculateOrderTotal];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    }
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
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
    
    
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"my JSON: %@",res);
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:[res count]];
    self.menu = [[NSMutableArray alloc] initWithCapacity:[res count]];
    for(NSDictionary *category in res) {
        NSArray *items = [category objectForKey:@"items"];
        NSString *categoryName = [category objectForKey:@"name"];
        NSMutableArray *menuCategory = [[NSMutableArray alloc] initWithCapacity:[items count]];
        NSMutableArray *tableSection = [[NSMutableArray alloc] initWithCapacity:[items count]];
        Item *categoryItem = [[Item alloc] initWithName:categoryName andCount:0];
        [menuCategory addObject:categoryItem];
        for(NSDictionary *item in items)
        {
            NSInteger price = [[item objectForKey:@"price"] integerValue];
            NSString *name = [item valueForKey:@"name"];
            Item *item = [[Item alloc] initWithName:name andPrice:price];
            NSLog(@"\nMenu : %@", self.menu);
            [menuCategory addObject:item];
            [tableSection addObject:name];
        }
        NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:
                       categoryName, POPDCategoryTitle,
                       tableSection, POPDSubSection,
                       nil];

        [tableData addObject:section];
        [self.menu addObject:menuCategory];
    }
    
    
    
    
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
    ShnackOrderItemCell *itemCell = (ShnackOrderItemCell *)cell;
    Item *item = self.menu[indexPath.section][indexPath.row];
    
    itemCell.name.text = item.name;
    itemCell.price.text = [NSString stringWithFormat:@"$%d.%02d", item.price/100, item.price%100];
    itemCell.count.text = [NSString stringWithFormat:@"%d", item.count];
    
    [itemCell.plusButton addTarget:self action:@selector(increaseCountByOne:) forControlEvents:UIControlEventTouchDown];
    [itemCell.minusButton addTarget:self action:@selector(decreaseCountByOne:) forControlEvents:UIControlEventTouchDown];
    itemCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void) willDisplayClosedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayOpenedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger categoryCount = ((Item *)self.menu[indexPath.section][0]).count;
    ShnackOrderCategoryCell *categoryCell = (ShnackOrderCategoryCell *)cell;
    if (categoryCount == 0) {
        categoryCell.count.hidden = YES;
    } else {
        categoryCell.count.hidden = NO;
        categoryCell.count.text = [NSString stringWithFormat:@"%ld", (long)categoryCount];
    }
    categoryCell.labelText.text = ((Item *)self.menu[indexPath.section][0]).name;
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

-(IBAction)increaseCountByOne:(id)sender
{
    if (globalOpenOrderMenu != self.menu) {
        globalOpenOrderMenu = self.menu;
        globalOpenOrderVendorID = globalCurrentVendorID;
        globalOpenOrderVendorName = globalCurrentVendorName;
    }

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
    Item *categoryItem = self.menu[indexPath.section][0];
    Item *item = self.menu[indexPath.section][indexPath.row];
    item.count++;
    categoryItem.count++;
        
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(IBAction)decreaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
    Item *categoryItem = self.menu[indexPath.section][0];
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

@end
