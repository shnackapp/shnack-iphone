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
  self.option_name_for_mod = @"";

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
  Option *option = self.options[indexPath.row];
  if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 0)
  {
    SizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"size" forIndexPath:indexPath];
    cell.picker.tag = indexPath.row;
    [cell.picker addTarget:self action:@selector(singleSelectSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.option.text = [NSString stringWithFormat:@"%@", [option valueForKey:@"name"]];
    cell.picker.on = NO;
    
    NSString *price = [NSString stringWithFormat:@"$%@", [option valueForKey:@"price"]];
    if([[option valueForKey:@"price"] integerValue] == 0 )
    {
    cell.price_label.text = @"";
    }
    else
    {
    cell.price_label.text = price;
    }

    
    return cell;
  }
  else if([[globalCurrentModifier valueForKey:@"mod_type"]integerValue] == 1)
  {
    SingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"single_select" forIndexPath:indexPath];
    cell.picker.tag = indexPath.row;
    [cell.picker addTarget:self action:@selector(singleSelectSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.option.text = [NSString stringWithFormat:@"%@", [option valueForKey:@"name"]];
    cell.picker.on = NO;
    NSString *price = [NSString stringWithFormat:@"$%@", [option valueForKey:@"price"]];
    if([[option valueForKey:@"price"] integerValue] == 0  )
    {
      cell.price_label.text = @"";
    }
    else
    {
      cell.price_label.text = price;
    }
    return cell;
  }
  else
  {
    MultipleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"multiple_select" forIndexPath:indexPath];
    cell.picker.tag = indexPath.row;
    [cell.picker addTarget:self action:@selector(multipleSelectSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.option.text = [NSString stringWithFormat:@"%@", [option valueForKey:@"name"]];
    cell.picker.on = NO;
    NSString *price = [NSString stringWithFormat:@"$%@", [option valueForKey:@"price"]];
    if([[option valueForKey:@"price"] integerValue] == 0)
    {
      cell.price_label.text = @"";
    }
    else
    {
      cell.price_label.text = price;
    }
    return cell;
  }
}

-(void) singleSelectSwitchAction:(id)sender
{
  NSLog(@"here is sender: %@", sender);
  UISwitch * cell_switch =  (UISwitch *)sender;
  if(cell_switch.on)
  {
    selectedOptionIndexPathRow = cell_switch .tag;
    Option *option = self.options[cell_switch.tag];
    globalCurrentOption = option;
    NSLog(@"my switch is on and here is row %ld", (long)cell_switch.tag);
    [self turnOffOtherSwitches:cell_switch.tag];
    if([[[option valueForKey:@"price"] stringValue]  isEqual: @""])
    {
      [self setDetailTextOnModifier:[option valueForKey:@"name"] andPrice:0];
    }
    else
    {
    [self setDetailTextOnModifier:[option valueForKey:@"name"] andPrice:[[option valueForKey:@"price"] integerValue]];
    }
  }
}

-(void) multipleSelectSwitchAction:(id)sender
{
  UISwitch * cell_switch =  (UISwitch *)sender;
  if(cell_switch.on)
  {
    Option *option = self.options[cell_switch.tag];
    NSString *option_name = [[option valueForKey:@"name"] stringByAppendingString:@" "];
    self.option_name_for_mod = [self.option_name_for_mod stringByAppendingString:option_name];
    NSLog(@"my switch is on and here is row %ld", (long)cell_switch.tag);
    [self setDetailTextOnModifier:(NSString *)self.option_name_for_mod andPrice:[[option valueForKey:@"price"] integerValue]];
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

-(void)setDetailTextOnModifier:(NSString *)option_name andPrice:(NSInteger)price
{
  for (int i =0; i < [[self.navigationController viewControllers] count]; i++)
  {
    UIViewController *aController = [[self.navigationController viewControllers] objectAtIndex:i];
    if ([aController isKindOfClass:[ModifierViewController class]])
    {
      ModifierViewController *mods = (ModifierViewController *)aController;
      [mods refreshTableToSetDetailText:option_name andPrice:price andIndex:(NSIndexPath *) selectedModIndexPath];
    }
  }
}

@end
