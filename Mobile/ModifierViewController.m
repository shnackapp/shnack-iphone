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
#import "Option.h"

@interface ModifierViewController ()

@end

@implementation ModifierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.estimatedRowHeight = 70;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  self.option_names = [[NSMutableArray alloc] init];
  self.option_prices = [[NSMutableArray alloc] init];
  self.modifiers = [[NSMutableArray alloc] init];
  self.items = [[NSMutableArray alloc] init];
  self.multi_options = [[NSMutableArray alloc] init];
  globalArrayModifiers = [[NSMutableArray alloc] init];

  globalOpenOrderVendorID = globalCurrentVendorID;
  [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];

  
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
  
   return 65;
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
    cell.quantity.text = [NSString stringWithFormat:@"%ld", (long)globalCurrentItem.count];

    [cell.minusButton setStyle:BButtonStyleBootstrapV3];
    [cell.plusButton setStyle:BButtonStyleBootstrapV3];
    
    [cell.plusButton setButtonCornerRadius:[NSNumber numberWithFloat:5.0f]];
    [cell.minusButton setButtonCornerRadius:[NSNumber numberWithFloat:5.0f]];

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
    cell.modifier.adjustsFontSizeToFitWidth = YES;
    cell.options.text = @"";
    return cell;
  }
}

- (void) refreshTableToSetDetailText:(NSMutableArray*) option_labels andPrice:(NSMutableArray*) price_or_prices andIndex:(NSIndexPath *)indexPath
{
  ModifierTableViewCell *cell = (ModifierTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  [self.option_prices  addObject: price_or_prices];
  [self.option_names addObject:option_labels];
  
  NSString *price = @"";
  NSString *option = @"";
  NSString *formatted_subtitle = @"";
  
  if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 0 || [[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 1)
  {
    NSMutableArray * single_option = [[NSMutableArray alloc] initWithCapacity:1];
    [single_option addObject:globalCurrentOption];
    Modifier *order_mod = [[Modifier alloc] initWithName:
                           [globalCurrentModifier valueForKey:@"name"] andModType:
                           [[globalCurrentModifier valueForKey:@"mod_type"] integerValue] andOptions:
                           single_option];
    
    [globalArrayModifiers addObject:order_mod];
  }
  
  if([[globalCurrentModifier valueForKey:@"mod_type"] integerValue] == 2)
  {//store the options selected and create a mod with all of those options instead of just one
    NSLog(@"options: %@", self .option_names);
    for(NSInteger i=0; i<[self.option_names count];i++)
    {
      if([[self.option_names objectAtIndex:i][0] isEqualToString:@""])
      {
        NSLog(@"DONothing");
      }
      else {
        if(self.option_prices == nil)
        {
          Option *op = [[Option alloc] initWithName:[self.option_prices objectAtIndex:i][0] andPrice:0];
          [self.multi_options addObject:op];
          
        }
        else
        {
          Option *op = [[Option alloc] initWithName:[self.option_names objectAtIndex:i][0] andPrice:[[self.option_prices objectAtIndex:i][0] integerValue]];
          [self.multi_options addObject:op];
          
        }
      }
    }
    if([self.multi_options count] != 0)
    {
      Modifier *order_mod = [[Modifier alloc] initWithName:
                              [globalCurrentModifier valueForKey:@"name"] andModType:
                              [[globalCurrentModifier valueForKey:@"mod_type"] integerValue] andOptions:
                              self.multi_options];
      [globalArrayModifiers addObject:order_mod];
    }
  }


  if([price_or_prices count] >1 && [option_labels count] > 1)//if multi_select
  {
    for(NSInteger i = 0; i < [price_or_prices count]; i++)//length of each array should match
    {
      price = [NSString stringWithFormat:@"+$%ld.%02ld",
               [[price_or_prices objectAtIndex:i] integerValue]/100,
               [price_or_prices[i] integerValue] %100];
      option = [NSString stringWithFormat:[option_labels objectAtIndex:i]];
      
      NSString *formatted_price = [NSString stringWithFormat:@" ( %@ )", price];

      NSString *option_and_price = [option stringByAppendingString:formatted_price];
      formatted_subtitle = [[formatted_subtitle stringByAppendingString: option_and_price] stringByAppendingString:@", "];
    }
    cell.options.text = formatted_subtitle;
  }
  else if ([price_or_prices count] == 1 && [option_labels count] == 1)//if single select or only one multi_select
  {
    price = [NSString stringWithFormat:@"+$%ld.%02ld",
            [[price_or_prices objectAtIndex:0] integerValue]/100,
            [price_or_prices[0] integerValue] %100];
    
    option = option_labels[0];
    NSString *formatted_price = [NSString stringWithFormat:@" ( %@ )", price];
    NSString *option_and_price = [option stringByAppendingString:formatted_price];
    formatted_subtitle = [formatted_subtitle stringByAppendingString: option_and_price];
    cell.options.text = formatted_subtitle;
  }
  else//if none chosen, i dont think it will ever get here because i send default rather than empty
  {
    cell.options.text = @"";
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section > 0)
  {
  selectedModIndexPath = [self.tableView indexPathForSelectedRow];
  globalCurrentModifier = self.modifiers[indexPath.row];
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}

-(IBAction)addToCart:(id)sender
{
  Item *order_item = [[Item alloc] initWithName:
                      globalCurrentItem.name andPrice:
                      globalCurrentItem.price andCount:
                      globalCurrentItem.count andDescription:
                      globalCurrentItem.description andModifiers:
                      globalArrayModifiers];
  
  [globalArrayOrderItems addObject:order_item];
  
  
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
