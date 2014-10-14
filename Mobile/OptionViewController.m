//
//  OptionViewController.m
//  Shnack
//
//  Created by Spencer Neste on 10/12/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "OptionViewController.h"
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
#import "Option.h"
#import "SizeTableViewCell.h"
#import "SingleTableViewCell.h"
#import "MultipleTableViewCell.h"



@interface OptionViewController ()

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.modifiers = [[NSMutableArray alloc] init];
  self.items = [[NSMutableArray alloc] init];
  self.options = [[NSMutableArray alloc] init];
  
  
  for (NSInteger i = 0; i < [globalOpenOrderMenu count]; i++)
  {
    NSArray *category = globalOpenOrderMenu[i];
    NSLog(@"category %@", globalOpenOrderMenu[i]);
    
    for (NSInteger j = 1; j < [category count]; j++)
    {
      Item *item = category[j];
      [self.modifiers addObject:item.modifiers];
      [self.items addObject:category[j]];
      NSLog(@"number of modifiers for item: %lu", (unsigned long)[item.modifiers count]);
      for(NSInteger k = 0; k < [item.modifiers count]; k++)
      {
        Modifier *modifier = item.modifiers[k];
        NSLog(@"modifier_name: %@", [item.modifiers[k] name]);
        
        for(NSInteger l = 0; l < [modifier.options count]; l++)
        {
          [self.options addObject:modifier.options[l]];
        }
      }
      globalCurrentModifier = [[self.modifiers[selectedLocationIndexPath.section-1][selectedLocationIndexPath.row] name] capitalizedString];
    }
  }
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
  
  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  label.textAlignment = NSTextAlignmentCenter;
  // ^-Use UITextAlignmentCenter for older SDKs.
  label.textColor = [UIColor whiteColor]; // change this color
  self.navigationItem.titleView = label;
  label.text = globalCurrentModifier;
  [label sizeToFit];

  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
  // Return the number of rows in the section.
     return [self.options count];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath Section: %ld %ld", (long)indexPath.section,(long)indexPath.row);

  Modifier *modifier = self.modifiers[selectedLocationIndexPath.section][selectedLocationIndexPath.row];
  Option *option = self.options[indexPath.row];
  if(modifier.mod_type == 0)
  {
    SizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"size" forIndexPath:indexPath];
    cell.option.text = [NSString stringWithFormat:@"%@", option.name];
    return cell;

  }
  else if(modifier.mod_type == 1)
  {
    SingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"single_select" forIndexPath:indexPath];
    cell.option.text = [NSString stringWithFormat:@"%@", option.name];
    return cell;
  }
  else
  {
    MultipleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"multiple_select" forIndexPath:indexPath];
    cell.option.text = [NSString stringWithFormat:@"%@", option.name];
    return cell;

  }
  
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
