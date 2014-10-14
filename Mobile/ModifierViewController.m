//
//  ModifierViewController.m
//  Shnack
//
//  Created by Spencer Neste on 10/6/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ModifierViewController.h"
#import "ModifierTableViewCell.h"
#import "Item.h"
#import "ShnackOrderItemCell.h"
#import "QuantityTableViewCell.h"
#import "ShnackOrderTotalCell.h"
#import "ObjectWithNameAndID.h"
#import "RESideMenu.h"
#import "POPDCell.h"
#import "ShnackOrderCategoryCell.h"
#import "NSObject_Constants.h"
#import "UIViewController+CWPopup.h"
#import "CartPopViewController.h"
#import "ShnackMenuViewController.h"
#import "Modifier.h"

@interface ModifierViewController ()

@end

@implementation ModifierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.modifiers = [[NSMutableArray alloc] init];
  self.items = [[NSMutableArray alloc] init];

  
  for (NSInteger i = 0; i < [globalOpenOrderMenu count]; i++)
  {
    NSArray *category = globalOpenOrderMenu[i];
    NSLog(@"category %@", globalOpenOrderMenu[i]);
    
    for (NSInteger j = 1; j < [category count]; j++)
    {
      Item *item = category[j];
      [self.modifiers addObject:item.modifiers];
      [self.items addObject:category[j]];
      
//      self.modifiers = item.modifiers;
//      NSLog(@"number of modifiers for item: %lu", (unsigned long)[item.modifiers count]);
//      for(NSInteger k = 0; k < [self.modifiers count]; k++)
//      {
//        NSLog(@"item_mods name: %@", items[j]);
//      }
    }
//    [self.modifiers removeAllObjects];
  }
  
  globalCurrentItem = self.items[selectedLocationIndexPath.row-1];

//  for(NSDictionary *category in [global_menu valueForKey:@"categories"])
//  {
//    NSArray *items = [category objectForKey:@"items"];
//    for(NSDictionary *item in items)
//    {
//      self.modifiers = [item objectForKey:@"modifiers"];
//      NSInteger count = [self.modifiers count];
//      bool is_empty;
//      if(count == 0) is_empty=true;
//      else is_empty = false;
//      NSLog(@"mods is_empty %@", is_empty ? @YES:@NO);
//    }
//  }
  [self.tableView reloadData];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
  
  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  label.textAlignment = NSTextAlignmentCenter;
  // ^-Use UITextAlignmentCenter for older SDKs.
  label.textColor = [UIColor whiteColor]; // change this color
  self.navigationItem.titleView = label;
  label.text = globalCurrentItem.name;
  [label sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//  CGRect footerFrame = CGRectMake(0.0, self.tableView.bounds.size.height - 44, self.tableView.bounds.size.width, 44);
//  UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
//  footerView.backgroundColor = [UIColor redColor];
//  return footerView;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
  // Return the number of rows in the section.
  if(section == 0)
  {
    return 1;
  }
  else return [self.modifiers count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath Section: %ld %ld", (long)indexPath.section,(long)indexPath.row);
  if(indexPath.row == 0 && indexPath.section == 0)
  {
    Item *item = self.items[selectedLocationIndexPath.row-1];
    QuantityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quantity" forIndexPath:indexPath];
    cell.quantity.text = [NSString stringWithFormat:@"%d", item.count];

    [cell.minusButton setStyle:BButtonStyleBootstrapV3];
    [cell.plusButton setStyle:BButtonStyleBootstrapV3];
    
    [cell.minusButton setType:BButtonTypeDanger];
    [cell.plusButton setType:BButtonTypeSuccess];
    
    [cell.plusButton addTarget:self action:@selector(increaseCountByOne:) forControlEvents:UIControlEventTouchDown];
    [cell.minusButton addTarget:self action:@selector(decreaseCountByOne:) forControlEvents:UIControlEventTouchDown];
    
    return cell;
  }
  else
  {
    
    ModifierTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modifiers" forIndexPath:indexPath];
    Modifier *modifier = self.modifiers[indexPath.section][indexPath.row];
    NSString *label = [[NSString stringWithFormat:@"Choose Your %@", modifier.name] capitalizedString];
    cell.modifier.text = label;
    cell.options.text = @"";//remove this eventually, actually need to set htis when options are chosen from next view
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  selectedLocationIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
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
  NSIndexPath *quantityIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
  Item *item = self.items[selectedLocationIndexPath.row-1];
  item.count++;
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:quantityIndexPath] withRowAnimation:UITableViewRowAnimationNone];
  
}
-(IBAction)decreaseCountByOne:(id)sender
{
  CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
  NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
  
  Item *item = self.items[selectedLocationIndexPath.row-1];
  if(item.count > 0)
  {
    item.count--;
  }
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
