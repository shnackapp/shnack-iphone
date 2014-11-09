//
//  CartPopViewController.m
//  Mobile
//
//  Created by Spencer Neste on 8/9/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "CartPopViewController.h"
#import "UIViewController+CWPopup.h"
#import "BButton.h"
#import "NSString+FontAwesome.h"
#import "OpenOrderTableViewCell.h"
#import "Item.h"
#import "Modifier.h"
#import "Option.h"
#import "SubtotalTableViewCell.h"

@interface CartPopViewController ()

@end

@implementation CartPopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  self.cart.text = @"My Order";
  self.cart.font =[UIFont fontWithName:@"Dosis-Bold" size:20];
  self.cart.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  self.cart.textAlignment = NSTextAlignmentCenter;
  self.cart.textColor = [UIColor colorWithRed:0.32f green:0.64f blue:0.32f alpha:1.00f]; // change this color
    [self.cart sizeToFit];
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:5.0f]];
  self.order_total = 0;
 
  [self.closeCart setStyle:BButtonStyleBootstrapV3];
  [self.closeCart setType:BButtonTypeDefault];
  self.closeCart.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
  self.closeCart.titleLabel.text = @"X";
  self.closeCart.titleLabel.textColor = [UIColor redColor];
    
  [self.checkoutButton setStyle:BButtonStyleBootstrapV3];
  [self.checkoutButton setType:BButtonTypeSuccess];
  [self.checkoutButton addAwesomeIcon:FAIconMoney beforeTitle:YES];

  
  self.checkoutButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:18];
  self.checkoutButton.titleLabel.text = @"Checkout";

  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [super viewDidLoad];
  
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
  // Return the number of rows in the section.
  
  return [globalArrayOrderItems count]+1;//+1 for the subtotal cell
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row == [globalArrayOrderItems count])
  {
    return 60;
  }
  else return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return @"Item                           Qty.       Price";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.row != [globalArrayOrderItems count])
  {
    OpenOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"OpenOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"order"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"order"];
    }
    Item *item = globalArrayOrderItems[indexPath.row];
    cell.item_name.text = item.name;
    NSString * price = [NSString stringWithFormat:@"$%ld.%02ld", (item.count *item.price)/100 ,(item.count *item.price )%100];
    cell.item_price.text = price;
    self.order_total += (item.count * item.price);
    NSString *all_info = @"";
    for(NSInteger i = 0; i < [item.modifiers count]; i++)
    {
      NSString *mod_name = [((Modifier*)item.modifiers[i]).name capitalizedString];
      NSMutableArray *options = ((Modifier*)item.modifiers[i]).options;
      NSString *options_string = @"";
      for(NSInteger j =0; j < [options count]; j++)
      {
        NSString *option = ((Option*)options[j]).name;
        options_string = [options_string stringByAppendingString:option];
      }
      NSString *mod_and_options = [[NSString stringWithFormat:@" %@:",mod_name]
               stringByAppendingString:[NSString stringWithFormat:@" %@",options_string]];
      all_info = [[all_info stringByAppendingString:mod_and_options]stringByAppendingString:@", \n"];
    }
    cell.modifier_name.text = all_info;
    cell.modifier_name.font = [UIFont fontWithName:@"Dosis-Bold" size:9];
    cell.modifier_name.adjustsFontSizeToFitWidth = YES;
    cell.quantity.text = [NSString stringWithFormat:@"%ld",(long)item.count];
    
    return cell;
  }
  else
  {
    //make this the subtotal and ttoal cell
    SubtotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subtotal"];
    if(!cell)
    {
      [tableView registerNib:[UINib nibWithNibName:@"SubtotalTableViewCell" bundle:nil] forCellReuseIdentifier:@"subtotal"];
      cell = [tableView dequeueReusableCellWithIdentifier:@"subtotal"];
    }
    NSString * price = [NSString stringWithFormat:@"$%ld.%02ld", self.order_total/100,self.order_total%100];
    cell.subtotal.text = [NSString stringWithFormat:@" Subtotal: %@",price];
    cell.total.text= [NSString stringWithFormat:@" Total: %@",price];
    cell.subtotal.font = [UIFont fontWithName:@"Dosis-Bold" size:12];
    cell.total.font = [UIFont fontWithName:@"Dosis-Bold" size:12];

    return cell;
  }
}

-(IBAction)checkout
{
    NSLog(@"checking out & button text %@", self.checkoutButton.titleLabel.text);
  
  
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
