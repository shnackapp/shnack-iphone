//
//  OptionViewController.m
//  Shnack
//
//  Created by Spencer Neste on 10/12/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "OptionViewController.h"

#import "ObjectWithNameAndID.h"
#import "RESideMenu.h"
#import "NSObject_Constants.h"
#import "UIViewController+CWPopup.h"
#import "CartPopViewController.h"
#import "ShnackMenuViewController.h"
#import "ModifierViewController.h"

#import "Modifier.h"
#import "Option.h"
#import "Item.h"

#import "POPDCell.h"
#import "ModifierTableViewCell.h"
#import "ShnackOrderCategoryCell.h"
#import "ShnackOrderItemCell.h"
#import "QuantityTableViewCell.h"
#import "ShnackOrderTotalCell.h"
#import "SizeTableViewCell.h"
#import "SingleTableViewCell.h"
#import "MultipleTableViewCell.h"
#import "ModifierViewController.h"

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

  [self.apply_button setStyle:BButtonStyleBootstrapV3];
  [self.apply_button setType:BButtonTypeFacebook];
  
  NSArray *options = [globalCurrentModifier valueForKey:@"options"];
  
  for(NSInteger i = 0; i< [options count]; i++)
  {
    [self.options addObject:[options objectAtIndex:i]];
  }

  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor]; // change this color
  self.navigationItem.titleView = label;
  label.text = [[globalCurrentModifier valueForKey:@"name" ] capitalizedString];
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
  Option *option = self.options[indexPath.row];
  if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 0)
  {
    SizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"size" forIndexPath:indexPath];
    cell.option.text = [NSString stringWithFormat:@"%@", [option valueForKey:@"name"]];
    cell.picker.on = NO;
        
    
    return cell;
  }
  else if([[globalCurrentModifier valueForKey:@"mod_type"]integerValue] == 1)
  {
    SingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"single_select" forIndexPath:indexPath];
    cell.option.text = [NSString stringWithFormat:@"%@", [option valueForKey:@"name"]];
    cell.picker.on = NO;

    return cell;
  }
  else
  {
    MultipleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"multiple_select" forIndexPath:indexPath];
    cell.option.text = [NSString stringWithFormat:@"%@", [option valueForKey:@"name"]];
    cell.picker.on = NO;

    return cell;
  }
}

@end
