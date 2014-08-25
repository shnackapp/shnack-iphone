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
#import "UIViewController+CWPopup.h"
#import "CartPopViewController.h"



@interface ShnackMyOrderViewController ()  <POPDDelegate>
@property (strong, nonatomic) NSMutableArray *selectedItems;
@end

@implementation ShnackMyOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    self.useBlurForPopup = YES;
    
    self.tableView.popDownDelegate = self;
        self.tableView.dataSource = self.tableView;
    
    
        [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
        [self.checkoutButton setStyle:BButtonStyleBootstrapV3];
        [self.checkoutButton setType:BButtonTypeDanger];
    
        self.vendorName.text = globalCurrentVendorName;

        if (globalCurrentVendorID == globalOpenOrderVendorID) {
        
                self.selectedItems = [[NSMutableArray alloc] init];
        
                NSMutableArray *tableData = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < [globalOpenOrderMenu count]; i++)
                {
                        NSArray *category = globalOpenOrderMenu[i];
                        Item *categoryItem = category[0];
                        NSString *categoryName = categoryItem.name;
                        if (categoryItem.count > 0)
                        {
                                NSMutableArray *tableSection = [[NSMutableArray alloc] init];
                                NSMutableArray *selectedSection = [[NSMutableArray alloc] init];
                                [selectedSection addObject:categoryItem];
                                [self.selectedItems addObject:selectedSection];
                                for (NSInteger j = 1; j < [category count]; j++)
                                {
                                Item *item = category[j];
                                if (item.count > 0)
                                {
                                [selectedSection addObject:item];
                                [tableSection addObject:item.name];
                                }
                                }
                                NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:categoryName, POPDCategoryTitle,tableSection, POPDSubSection,nil];
                                [tableData addObject:section];
                        }
                }
               [self.tableView setMenuSections:tableData withAllSectionsOpen:YES];
            }
        NSInteger total = [self calculateOrderTotal];
    NSLog(@"------->%li",(long)total);
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    globalCurrentOrderAmount = (long)total;
    NSLog(@"This is the ammount being charged on the card @%i",globalCurrentOrderAmount);
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
    
}

-(IBAction)presentCart
{
    NSLog(@"I PRESSED IT!");
        
     CartPopViewController *cart = [[CartPopViewController alloc] initWithNibName:@"CartPopViewController" bundle:nil];
    [self presentPopupViewController:cart animated:YES completion:nil];
    
}

- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
    }
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
    Item *item = self.selectedItems[indexPath.section][indexPath.row];
    
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
    NSInteger categoryCount = ((Item *)self.selectedItems[indexPath.section][0]).count;
    ShnackOrderCategoryCell *categoryCell = (ShnackOrderCategoryCell *)cell;
    if (categoryCount == 0) {
        categoryCell.count.hidden = YES;
    } else {
        categoryCell.count.hidden = NO;
        categoryCell.count.text = [NSString stringWithFormat:@"%ld", (long)categoryCount];
    }
    categoryCell.labelText.text = ((Item *)self.selectedItems[indexPath.section][0]).name;
}


-(NSInteger)calculateOrderTotal
{
    NSInteger total = 0;
    for (NSArray *category in self.selectedItems) {
        for (NSInteger i = 1; i < [category count]; i++) {
            total += ((Item *)category[i]).price * ((Item *)category[i]).count;
        }
    }
    
    return total;
}

-(IBAction)increaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    
    Item *item = globalOpenOrderMenu[indexPath.section][indexPath.row];
    Item *categoryItem = self.selectedItems[indexPath.section][0];
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
    
    Item *categoryItem = self.selectedItems[indexPath.section][0];
        Item *item = self.selectedItems[indexPath.section][indexPath.row];
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


 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     
//     if(segue.identifier isEqualToString:@"view_receipt")
//     {
//         
//     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 

@end