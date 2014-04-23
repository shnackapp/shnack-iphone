//
//  ShnackMyOrderViewController.m
//  Mobile
//
//  Created by Jake Staahl on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ShnackMyOrderViewController.h"
#import "Item.h"
#import "ShnackOrderItemCell.h"
#import "ShnackOrderTotalCell.h"
#import "ObjectWithNameAndID.h"
#import "RESideMenu.h"
#import "POPDCell.h"
#import "ShnackOrderCategoryCell.h"

@interface ShnackMyOrderViewController ()  <POPDDelegate>

@end

@implementation ShnackMyOrderViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.dataSource = self;
    
    
    /*
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:[globalOpenOrder count]];
    for (NSDictionary *openOrderSection in globalOpenOrder )
        NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:
                             categoryName, POPDCategoryTitle,
                             tableSection, POPDSubSection,
                             nil];
        [tableData addObject:section];
     */
    
    
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void) willDisplayLeafSubCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    ShnackOrderItemCell *itemCell = (ShnackOrderItemCell *)cell;
    Item *item = globalOpenOrderMenu[indexPath.section][indexPath.row];
    
    itemCell.name.text = item.name;
    itemCell.price.text = [NSString stringWithFormat:@"$%d.%02d", item.price/100, item.price%100];
    itemCell.count.text = [NSString stringWithFormat:@"%d", item.count];
    
    [itemCell.plusButton addTarget:self action:@selector(increaseCountByOne:) forControlEvents:UIControlEventTouchDown];
    [itemCell.minusButton addTarget:self action:@selector(decreaseCountByOne:) forControlEvents:UIControlEventTouchDown];
}

-(void) willDisplayClosedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayOpenedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger categoryCount = [self calculateCategoryCount:indexPath.section];
    ShnackOrderCategoryCell *categoryCell = (ShnackOrderCategoryCell *)cell;
    if (categoryCount == 0) {
        categoryCell.count.hidden = YES;
    } else {
        categoryCell.count.hidden = NO;
        categoryCell.count.text = [NSString stringWithFormat:@"%ld", (long)categoryCount];
    }
    categoryCell.labelText.text = globalOpenOrderMenu[indexPath.section][0];
}


-(NSInteger)calculateOrderTotal
{
    NSInteger total = 0;
    for (NSArray *category in globalOpenOrderMenu) {
        for (NSInteger i = 1; i < [category count]; i++) {
            total += ((Item *)category[i]).price * ((Item *)category[i]).count;
        }
    }
    
    return total;
}

-(NSInteger)calculateCategoryCount:(NSInteger)section {
    NSInteger count = 0;
    NSInteger numItems = [((NSArray *)globalOpenOrderMenu[section]) count];
    for (NSInteger i = 1; i < numItems; i++) {
        count += ((Item *)globalOpenOrderMenu[section][i]).count;
    }
    return count;
}

-(IBAction)increaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
    Item *item = globalOpenOrderMenu[indexPath.section][indexPath.row];
    item.count++;
    
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%ld.%02ld", total/100, total%100];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(IBAction)decreaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
    Item *item = globalOpenOrderMenu[indexPath.section][indexPath.row];
    if(item.count > 0)
    {
        item.count--;
    }
    
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%ld.%02ld", total/100, total%100];
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