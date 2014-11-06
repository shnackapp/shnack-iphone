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
    self.cart.text = @"My Cart";
    self.cart.font =[UIFont fontWithName:@"Dosis-Bold" size:20];
    self.cart.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.cart.textAlignment = NSTextAlignmentCenter;
    self.cart.textColor = [UIColor colorWithRed:0.32f green:0.64f blue:0.32f alpha:1.00f]; // change this color
    [self.cart sizeToFit];
    
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:5.0f]];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 44)];
    label.font = [UIFont fontWithName:@"FontAwesome" size:20];
    label.text =  [NSString awesomeIcon:FAIconCheck];
    NSLog(@"icon %@",label.text);
    
    
    [self.closeCart setStyle:BButtonStyleBootstrapV3];
    [self.closeCart setType:BButtonTypeDefault];
    
    self.closeCart.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.closeCart.titleLabel.text = @"X";
    self.closeCart.titleLabel.textColor = [UIColor redColor];
    
    [self.checkoutButton setStyle:BButtonStyleBootstrapV3];
    [self.checkoutButton setType:BButtonTypeSuccess];
    
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
  
  return [globalArrayOrderItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  OpenOrderTableViewCell *cell = [[OpenOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"order"];
  cell.item_name.text = @"testing_name";
  cell.item_price.text = @"$1.23";
  cell.modifier_name.text = @"modnejcnekjc";
  cell.quantity.text = @"100";
  
  return cell;
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
