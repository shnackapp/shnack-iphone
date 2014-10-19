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
  
  globalOpenOrderVendorID = globalCurrentVendorID;
  
  [self.add_to_cart_button setStyle:BButtonStyleBootstrapV3];
  [self.add_to_cart_button setType:BButtonTypeFacebook];
  
  for(NSInteger i = 0; i< [globalCurrentItem.modifiers count]; i++)
  {
    [self.modifiers addObject:[globalCurrentItem.modifiers objectAtIndex:i]];
  }

  [self.tableView reloadData];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
  
  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  label.textAlignment = NSTextAlignmentCenter;
  // ^-Use UITextAlignmentCenter for older SDKs.
  label.textColor = [UIColor whiteColor]; // change this color
  self.navigationItem.titleView = label;
  label.text = [globalCurrentItem.name capitalizedString] ;
  [label sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
  else return [globalCurrentItem.modifiers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath Section: %ld %ld", (long)indexPath.section,(long)indexPath.row);
  if (globalCurrentItem.count == 0)
  {
    self.add_to_cart_button.enabled = NO;
  }
  else
  {
    self.add_to_cart_button.enabled = YES;
  }
  

  if(indexPath.row == 0 && indexPath.section == 0)
  {
    QuantityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quantity" forIndexPath:indexPath];
    cell.quantity.text = [NSString stringWithFormat:@"%d", globalCurrentItem.count];

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
    NSString * mod_name = [globalCurrentItem.modifiers[indexPath.row] objectForKey:@"name"];
    NSString *label = [[NSString stringWithFormat:@"Choose Your %@", mod_name] capitalizedString];
    cell.modifier.text = label;
    cell.options.text = @"";
    return cell;
  }
}

- (void) refreshTableToSetDetailText:(NSString*) option_label andIndex:(NSIndexPath *)indexPath
{
  ModifierTableViewCell *cell = (ModifierTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  cell.options.text = option_label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedModIndexPath = [self.tableView indexPathForSelectedRow];
  globalCurrentModifier = self.modifiers[indexPath.row];
  
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)addToCart:(id)sender
{
  
  for (int i =0; i < [[self.navigationController viewControllers] count]; i++)
  {
    ShnackMenuViewController *menu = [[self.navigationController viewControllers] objectAtIndex:i];
    
    if ([menu isKindOfClass:[ShnackMenuViewController class]])
    {
      [self.navigationController popToViewController:menu animated:YES];
      [menu.tableView reloadData];

    }
    
  }
  
}


-(IBAction)increaseCountByOne:(id)sender
{

  CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
  NSIndexPath *quantityIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
  globalCurrentItem.count++;
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:quantityIndexPath] withRowAnimation:UITableViewRowAnimationNone];
  
}
-(IBAction)decreaseCountByOne:(id)sender
{

  CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
  NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
  
  if(globalCurrentItem.count > 0)
  {
    globalCurrentItem.count--;
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
