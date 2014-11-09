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
    cell.tag = [[globalCurrentItem.modifiers[indexPath.row] objectForKey:@"mod_type"] integerValue];
    return cell;
  }
}

- (void) refreshTableToSetDetailText:(NSMutableArray*) option_labels andPrice:(NSMutableArray*) price_or_prices andIndex:(NSIndexPath *)indexPath
{
  ModifierTableViewCell *cell = (ModifierTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  
  NSString *price = @"";
  NSString *option = @"";
  NSString *formatted_subtitle = @"";

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
  else//no options selected for multi select!
  {
    cell.options.text = @"No options selected";
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

-(void)createModifiers
{
  NSLog(@"Number of mods: %ld", (long)[self.tableView numberOfRowsInSection:1]);
  NSIndexPath *indexPath;
  for(NSInteger i = 0; i < [self.tableView numberOfRowsInSection:1]; i++)
  {
    indexPath = [NSIndexPath indexPathForRow:i inSection:1];
    ModifierTableViewCell *cell = (ModifierTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.options.text isEqualToString:@""])
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", @"Alert") message:NSLocalizedString(@"You have not selected some important information about your order! Please finish your order.", @"You have not selected some important information about your order! Please finish your order.") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
      NSLog(@"should present a popup");
      alert.tag = 100;
      self.COMPLETE_ORDER = NO;
      break;
      
    }
    else
    {
      self.COMPLETE_ORDER = YES;
      if(cell.tag == 0 || cell.tag == 1) //if single select
      {
        NSMutableArray *single_select_option = [[NSMutableArray alloc] init];
        NSArray *deconstructed_option = [cell.options.text componentsSeparatedByString:@"("];
        NSString *formatted_price = [deconstructed_option[1] stringByReplacingOccurrencesOfString:@"+" withString:@""];
        formatted_price = [formatted_price stringByReplacingOccurrencesOfString:@"$" withString:@""];
        formatted_price = [formatted_price stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSInteger price = [formatted_price floatValue] * 100;
        NSString * name = deconstructed_option[0];
        NSLog(@"HERE IS LABEL_ARRAY: %@ and PRICE: %ld", name,price);
        Option *option = [[Option alloc] initWithName:name andPrice:price];
        [single_select_option addObject:option];
        Modifier *order_mod = [[Modifier alloc] initWithName:[self.modifiers[indexPath.row] valueForKey:@"name"] andModType:[[self.modifiers[indexPath.row] valueForKey:@"mod_type"] integerValue] andOptions:single_select_option];
        [globalArrayModifiers addObject:order_mod];
    }
    if(cell.tag == 2)
    {
      NSArray *deconstructed_options = [cell.options.text componentsSeparatedByString:@","];
      if([deconstructed_options[0] isEqualToString:@"No options selected"])//either no selected options or just one(no comma)
      {
        NSLog(@"Dont make a mod if no options selected!");
      }
      if([deconstructed_options count] == 1 && ![deconstructed_options[0] isEqualToString:@"No options selected"])
      {
        NSMutableArray *single_multi_select_option = [[NSMutableArray alloc] init];
        NSArray *deconstructed_option = [cell.options.text componentsSeparatedByString:@"("];
        NSString *formatted_price = [deconstructed_option[1] stringByReplacingOccurrencesOfString:@"+" withString:@""];
        formatted_price = [formatted_price stringByReplacingOccurrencesOfString:@"$" withString:@""];
        formatted_price = [formatted_price stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSInteger price = [formatted_price floatValue]*100 ;
        NSString *name = deconstructed_option[0];
        NSLog(@"HERE IS LABEL_ARRAY: %@ and PRICE: %ld", deconstructed_option,price);
        Option *option = [[Option alloc] initWithName:name andPrice:price];
        [single_multi_select_option addObject:option];
        Modifier *order_mod = [[Modifier alloc] initWithName:
                 [self.modifiers[indexPath.row] valueForKey:@"name"] andModType:
                [[self.modifiers[indexPath.row] valueForKey:@"mod_type"] integerValue] andOptions: single_multi_select_option];
        [globalArrayModifiers addObject:order_mod];

      }
      if([deconstructed_options count] > 1)
      {
        for(NSInteger j = 0; j < [deconstructed_options count]; j++)
        {
          NSInteger price;
          NSString *name;
          NSArray *deconstructed_option = [deconstructed_options[j] componentsSeparatedByString:@"("];
          if([deconstructed_option count] == 1)
          {
            NSLog(@"false - there is no option just a space");
          }
          else
          {
            NSString *formatted_price = [deconstructed_option[1] stringByReplacingOccurrencesOfString:@"+" withString:@""];
            formatted_price = [formatted_price stringByReplacingOccurrencesOfString:@"$" withString:@""];
            formatted_price = [formatted_price stringByReplacingOccurrencesOfString:@")" withString:@""];
            price = [formatted_price floatValue] *100;
            name = deconstructed_option[0];
            NSLog(@"HERE IS LABEL_ARRAY: %@ and PRICE: %ld", deconstructed_option,price);
            Option *option= [[Option alloc] initWithName:name andPrice:price];
            [self.multi_options addObject:option];
          }
        }
        Modifier *order_mod = [[Modifier alloc] initWithName:
                  [self.modifiers[indexPath.row] valueForKey:@"name"] andModType:
                  [[self.modifiers[indexPath.row] valueForKey:@"mod_type"] integerValue] andOptions:
                  self.multi_options];
        [globalArrayModifiers addObject:order_mod];
      }
    }
   }
  }
}

-(IBAction)addToCart:(id)sender
{
  
  //make sure they have selected all modifiers before adding to cart
 // ModifierTableViewCell *cell = (ModifierTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
[self createModifiers];

if(self.COMPLETE_ORDER == NO)
{
  NSLog(@"incomplete order!");
}
else
{
   NSInteger total = globalCurrentItem.price;
  for(NSInteger j=0; j<[globalArrayModifiers count]; j++)
  {
    NSLog(@"@@@@@item: %@ and modifer %ld: %@", globalCurrentItem.name, j+1 ,[globalArrayModifiers[j] name]);
    NSLog(@"@@@@@options: %@, %@ ", [[globalArrayModifiers[j] valueForKey:@"options"] valueForKey:@"name"],[[globalArrayModifiers[j] valueForKey:@"options"] valueForKey:@"price"]);
    NSMutableArray *options = [globalArrayModifiers[j] valueForKey:@"options"];
    for(NSInteger k=0; k<[options count]; k++)
    {
      NSString *name = [[options objectAtIndex:k] valueForKey:@"name"];
      NSInteger price = [[[options objectAtIndex:k] valueForKey:@"price"] floatValue];
      Option *option = [[Option alloc] initWithName:name andPrice:price];
      if([option valueForKey:@"price"] != [NSNull null])
      {
        NSLog(@"here is my order option name and price %@ %@", [option valueForKey:@"name"], [option valueForKey:@"price"]);
        total += option.price;
      }
    }
  }
  Item *order_item = [[Item alloc] initWithName:
                      globalCurrentItem.name andPrice:
                      total  andCount:
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
