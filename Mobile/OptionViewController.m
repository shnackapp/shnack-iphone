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
  self.option_name_for_mod = [[NSMutableArray alloc] init];
  self.option_price_for_mod = [[NSMutableArray alloc] init];
  
  self.single_option_name_for_mod = [[NSMutableArray alloc] initWithCapacity:1];
  self.single_option_price_for_mod = [[NSMutableArray alloc] initWithCapacity:1];
  
  self.default_option_name = [[NSMutableArray alloc] init];
  self.default_option_price = [[NSMutableArray alloc] init];

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
-(void)viewDidAppear:(BOOL)animated
{
//  if(selectedOptionIndexPathRow != -1)
//  {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedOptionIndexPathRow inSection:0];
//    if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue]== 0)
//    {
//      if([self.options[selectedOptionIndexPathRow] isOn])
//      {
//      SizeTableViewCell *cell = (SizeTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//      cell.picker.on = YES;
//      }
//    }
//    
//    if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue]== 1)
//    {
//      if([self.options[selectedOptionIndexPathRow] isOn])
//      {
//      SingleTableViewCell *cell = (SingleTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
//      cell.picker.on = YES;
//      }
//    }
//  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath Section: %ld %ld", (long)indexPath.section,(long)indexPath.row);
  NSString *name = [self.options[indexPath.row] objectForKey:@"name"];
  NSInteger price;
  if([self.options[indexPath.row] objectForKey:@"price"] == [NSNull null] )
  {
    price = 0;
  }
  else
  {
    price = [[self.options[indexPath.row] objectForKey:@"price"] integerValue];
  }
  Option *option = [[Option alloc] initWithName:name andPrice:price];
  
  if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 0)
  {
    SizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"size" forIndexPath:indexPath];
    cell.picker.tag = indexPath.row;
    [cell.picker addTarget:self action:@selector(singleSelectSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.option.text = [NSString stringWithFormat:@"%@", option.name];
    if(indexPath.row == 0)
    {//default
    cell.picker.on = YES;
    self.DEFAULT_OPTION = YES;
    [self.default_option_name addObject:option.name];
    [self.default_option_price addObject:@(0)];
    globalCurrentOption = option;
    }
    else
    {
    cell.picker.on = NO;
    }
    NSString *price = [NSString stringWithFormat:@"+$%d.%02d", option.price/100, option.price%100];
    cell.price_label.text = price;
    return cell;
  }
  else if([[globalCurrentModifier valueForKey:@"mod_type"]integerValue] == 1)
  {
    SingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"single_select" forIndexPath:indexPath];
    cell.picker.tag = indexPath.row;
    [cell.picker addTarget:self action:@selector(singleSelectSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.option.text = [NSString stringWithFormat:@"%@", option.name];
    if(indexPath.row == 0)
    {//default
      cell.picker.on = YES;
      self.DEFAULT_OPTION = YES;
      [self.default_option_name addObject: option.name];
      [self.default_option_price addObject:@(0)];
      globalCurrentOption = option;
    }
    else
    {
      cell.picker.on = NO;
    }
    NSString *price = [NSString stringWithFormat:@"+$%d.%02d", option.price/100, option.price%100];
    cell.price_label.text = price;
    return cell;
  }
  else
  {
    MultipleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"multiple_select" forIndexPath:indexPath];
    cell.picker.tag = indexPath.row;
    [cell.picker addTarget:self action:@selector(multipleSelectSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.option.text = [NSString stringWithFormat:@"%@", option.name];
    cell.picker.on = NO;
    NSString *price = [NSString stringWithFormat:@"+$%d.%02d", option.price/100, option.price%100];
    cell.price_label.text = price;
    return cell;
  }
}

-(void) singleSelectSwitchAction:(id)sender
{
  NSLog(@"here is sender: %@", sender);
  UISwitch * cell_switch =  (UISwitch *)sender;
  if(cell_switch.on)
  {
    self.DEFAULT_OPTION = NO;
    selectedOptionIndexPathRow = cell_switch .tag;
    NSInteger price;
    if([self.options[cell_switch.tag] valueForKey:@"price"] == [NSNull null])
    {
      price = 0;
    }
    else
    {
      price = [[self.options[cell_switch.tag] valueForKey:@"price"] integerValue];
    }
    NSString *name = [self.options[cell_switch.tag] valueForKey:@"name"];
    Option *option = [[Option alloc] initWithName:name andPrice:price];
    globalCurrentOption = option;
    [self.single_option_name_for_mod addObject:option.name];
    NSNumber *num = [NSNumber numberWithInteger:option.price];
    [self.single_option_price_for_mod addObject:num];
    NSLog(@"my switch is on and here is row %ld", (long)cell_switch.tag);
    [self turnOffOtherSwitches:cell_switch.tag];
  }
}

-(void) multipleSelectSwitchAction:(id)sender
{
  UISwitch * cell_switch =  (UISwitch *)sender;
  if(cell_switch.on)
  {
    NSInteger price;
    self.DEFAULT_OPTION = NO;
    NSString *name = [self.options[cell_switch.tag] valueForKey:@"name"];
    if([self.options[cell_switch.tag] valueForKey:@"price"] == [NSNull null])
    {
      price = 0;
    }
    else
    {
      price = [[self.options[cell_switch.tag] valueForKey:@"price"] integerValue];
    }
    Option *option = [[Option alloc] initWithName:name andPrice:price];
    [self.option_name_for_mod addObject:option.name];
    NSNumber *num = [NSNumber numberWithInteger:option.price];
    [self.option_price_for_mod addObject:num];
    NSLog(@"my switch is on and here is row %ld", (long)cell_switch.tag);
  }
  if(!cell_switch.on)
  {
    if([self.option_name_for_mod count] <= 1)
    {
      [self.option_name_for_mod removeLastObject];
      [self.option_price_for_mod removeLastObject];
    }
    else if(cell_switch.tag >= [self.option_name_for_mod count])
    {
      [self.option_name_for_mod removeLastObject];
      [self.option_price_for_mod removeLastObject];
    }
    else
    {
      [self.option_name_for_mod removeObjectAtIndex:cell_switch.tag];
      [self.option_price_for_mod removeObjectAtIndex:cell_switch.tag];
    }
  }
}


-(void)viewWillDisappear:(BOOL)animated
{
  NSLog(@"please am i in here");
  if(self.DEFAULT_OPTION == YES)
  {
    [self setDetailTextOnModifier:self.default_option_name andPrice:self.default_option_price];
  }
  if(self.DEFAULT_OPTION == NO)
  {
    
    if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 0 || [[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 1)
    {
      //this is to remove the switches that could be toggled when a user is deciding which option
      NSInteger num_elements = [self.single_option_name_for_mod count];
      for(NSInteger j = 0; j < num_elements; j++)
      {
        if(j != [self.single_option_name_for_mod count] - 1)
        {
          [self.single_option_price_for_mod removeObjectAtIndex:0];
          [self.single_option_name_for_mod removeObjectAtIndex:0];
        }
      }
    [self setDetailTextOnModifier:self.single_option_name_for_mod andPrice:self.single_option_price_for_mod];
    }
    if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 2)
    {
      [self setDetailTextOnModifier:self.option_name_for_mod andPrice:self.option_price_for_mod];
    }
  }
}

-(void) turnOffOtherSwitches:(NSInteger ) rowToStayOn
{
  NSInteger number_of_cells = [self.tableView numberOfRowsInSection:0];
  for(NSInteger i = 0; i<number_of_cells; i++)
  {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    SizeTableViewCell *single = (SizeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(i == rowToStayOn)
    {
      single.picker.on = YES;
    }
    else
    {
      single.picker.on = NO;
    }
  }
}

-(void)setDetailTextOnModifier:(NSMutableArray *)options andPrice:(NSMutableArray *)prices
{
  for (int i =0; i < [[self.navigationController viewControllers] count]; i++)
  {
    UIViewController *aController = [[self.navigationController viewControllers] objectAtIndex:i];
    if ([aController isKindOfClass:[ModifierViewController class]])
    {
      ModifierViewController *mods = (ModifierViewController *)aController;
      [mods refreshTableToSetDetailText:options andPrice:prices andIndex:(NSIndexPath *) selectedModIndexPath];
    }
  }
}

@end
