//
//  ShnackMenuViewController2.m
//  Mobile
//
//  Created by Jake Staahl on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ShnackMenuViewController.h"
#import "Item.h"
#import "ShnackOrderItemCell.h"
#import "ShnackOrderTotalCell.h"
#import "ObjectWithNameAndID.h"
#import "RESideMenu.h"
#import "POPDCell.h"
#import "ShnackOrderCategoryCell.h"
#import "NSObject_Constants.h"
#import "UIViewController+CWPopup.h"
#import "CartPopViewController.h"
#import "Modifier.h"
#import "Option.h"
#import "NSString+FontAwesome.h"

@interface ShnackMenuViewController ()  <POPDDelegate>
@end

@implementation ShnackMenuViewController

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
  //disable swipe back in nav controller
  [self.tableView setLoading:YES];
  globalArrayOrderItems = [[NSMutableArray alloc] init];


  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
      self.navigationController.interactivePopGestureRecognizer.enabled = NO;
  }
  
  UIBarButtonItem *back_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(clearCurrentOrder)];
  self.navigationItem.leftBarButtonItem = back_button;

  globalCurrentVendorName = [globalArrayLocations[selectedLocationIndexPath.section][selectedLocationIndexPath.row] name];
  NSLog(@"top name %@",globalCurrentVendorName);
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];
  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor]; // change this color
  self.navigationItem.titleView = label;
  label.text = [globalCurrentVendorName capitalizedString];
  [label sizeToFit];
    
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
  tapRecognizer.numberOfTapsRequired = 1;
  tapRecognizer.delegate = self;
  [self.view addGestureRecognizer:tapRecognizer];// so you can dismiss on click!
  self.useBlurForPopup = NO;

  [super viewDidLoad];
  self.tableView.popDownDelegate = self;
  [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
  [self.checkoutButton setStyle:BButtonStyleBootstrapV3];
  [self.checkoutButton setType:BButtonTypeFacebook];
  [self.checkoutButton addAwesomeIcon:FAIconShoppingCart beforeTitle:YES];
  [self.checkoutButton addTarget:self action:@selector(presentCart) forControlEvents:UIControlEventTouchUpInside];
  self.checkoutButton.enabled = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    globalCurrentVendorID = [globalArrayLocations[selectedLocationIndexPath.section][selectedLocationIndexPath.row] object_id];
    if (globalCurrentVendorID != globalOpenOrderVendorID)
    {
      self.responseData = [NSMutableData data];
      NSString *url = [NSString stringWithFormat:@"%@/get_menu_for_vendor?object_id=%ld", BASE_URL,(long)globalCurrentVendorID];
      NSString *api_key = [NSString stringWithFormat:API_KEY];
      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
      [request setHTTPMethod:@"GET"];
      [request setValue:api_key forHTTPHeaderField:@"Authorization"];
      [[NSURLConnection alloc] initWithRequest:request delegate:self];

    }
  NSInteger total = [self calculateOrderTotal];
  self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
  self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
  if(globalCurrentItem.count == 0)
  {
    self.checkoutButton.enabled = NO;
  }
  else
  {
    self.checkoutButton.enabled = YES;
  }
    NSInteger total = [self calculateOrderTotal];
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [self.tableView setLoading:NO];
  NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
  NSError *myError = nil;
  NSArray *menu = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
  NSMutableDictionary *modifiers = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
  NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:[menu count]];
  self.menu = [[NSMutableArray alloc] initWithCapacity:[menu count]];
  global_menu = modifiers;
  NSLog(@"globalopenordermenu %@", global_menu);
  for(NSDictionary *category in [menu valueForKey:@"categories"])
  {
    NSArray *items = [category objectForKey:@"items"];
    NSString *categoryName = [category objectForKey:@"name"];
    NSMutableArray *menuCategory = [[NSMutableArray alloc] initWithCapacity:[items count]];
    NSMutableArray *tableSection = [[NSMutableArray alloc] initWithCapacity:[items count]];
    NSLog(@"items in category: %lu", (unsigned long)[items count]);
    Item *categoryItem = [[Item alloc] initWithName:categoryName andCount:0];
    [menuCategory addObject:categoryItem];
    self.modifiers = [[NSMutableArray alloc] init];
    self.options = [[NSMutableArray alloc] init];
    
    for(NSDictionary *item in items)
    {
        NSInteger price = [[item objectForKey:@"price"] integerValue];
        NSString *name = [item  objectForKey:@"name"];
        NSString *description = [[item objectForKey:@"description" ] isKindOfClass:[NSNull class]] ? @"No Description" : [item objectForKey:@"description"];
        NSMutableArray *modifiers = [item objectForKey:@"modifiers"];
      Item *new_item = [[Item alloc] initWithName:name andPrice:price andCount:0 andDescription:description andModifiers:modifiers];
        [menuCategory addObject:new_item];
        [tableSection addObject:name];
    }
    NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:
                  categoryName, POPDCategoryTitleTV,
                  tableSection, POPDSubSectionTV,
                  nil];
    [tableData addObject:section];
    [self.menu addObject:menuCategory];
  }
  globalOpenOrderMenu = self.menu;
  [self.tableView setMenuSections:tableData];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void) willDisplayLeafSubCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ShnackOrderItemCell *itemCell = (ShnackOrderItemCell *)cell;
    Item *item = self.menu[indexPath.section][indexPath.row];
    NSLog(@"identifier: %@",itemCell.reuseIdentifier);
    itemCell.name.text = item.name;
    itemCell.price.text = [NSString stringWithFormat:@"$%d.%02d", item.price/100, item.price%100];
    itemCell.description.text =item.description;
    itemCell.description.textColor = [UIColor darkGrayColor];
    itemCell.selectionStyle = UITableViewCellSelectionStyleGray;
}

-(void) willDisplayClosedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayOpenedCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [self willDisplayCategoryCell:cell atIndexPath:indexPath];
}

-(void) willDisplayCategoryCell:(POPDCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"index path section %ld", (long)indexPath.section);

  ShnackOrderCategoryCell *categoryCell = (ShnackOrderCategoryCell *)cell;
  if(indexPath.section >= [self.menu count])
  {
    NSLog(@"im doing nothing");
  }
  else
  {
    NSInteger categoryCount = [self calculateCategoryCount:indexPath.section];
    categoryCell.labelText.text = ((Item *)self.menu[indexPath.section][0]).name;
    if (categoryCount == 0) {
      categoryCell.count.hidden = YES;
    } else {
      categoryCell.count.hidden = NO;
      categoryCell.count.text = [NSString stringWithFormat:@"%ld", (long)categoryCount];
    }
  }
  }

-(NSInteger)calculateCategoryCount:(NSInteger)section {
  NSInteger count = 0;
 
  NSInteger numItems = [((NSArray *)self.menu[section]) count];
  for (NSInteger i = 1; i < numItems; i++) {
    count += ((Item *)self.menu[section][i]).count;
  }
  return count;
}

-(NSInteger)calculateOrderTotal
{
  NSInteger total = 0;
  for (NSArray *category in self.menu)
  {
    for (NSInteger i = 1; i < [category count]; i++)
    {
      total += ((Item *)category[i]).price * ((Item *)category[i]).count;
    }
  }
  if(globalArrayOrderItems != nil)
  {
    for(NSInteger i=0; i<[globalArrayOrderItems count]; i++)
    {
      NSMutableArray *modifiers = [globalArrayOrderItems[i] valueForKey:@"modifiers"];
      for(NSInteger j=0; j<[modifiers count]; j++)
      {
        NSMutableArray *options = [modifiers valueForKey:@"options"];
        for(NSInteger k=0; k<[options count]; k++)
        {
          NSString *name = [[options objectAtIndex:k][0] valueForKey:@"name"];
          NSInteger price = [[[options objectAtIndex:k][0] valueForKey:@"price"] integerValue];
          Option *option = [[Option alloc] initWithName:name andPrice:price];
          NSLog(@"option.price %ld", (long)option.price);
          if([option valueForKey:@"price"] != [NSNull null])
          {
          NSLog(@"here is my order option name and price %@ %@", [option valueForKey:@"name"], [option valueForKey:@"price"]);
          total += option.price;
            NSLog(@"total %ld", (long)total);
          }
        }

      }

    }
    
  } 
  
  return total;
}

-(IBAction)presentCart
{
    self.tableView.userInteractionEnabled = NO;//so the view behind popup is disabled
    CartPopViewController *cart = [[CartPopViewController alloc] initWithNibName:@"CartPopViewController" bundle:nil];
    [self presentPopupViewController:cart animated:YES completion:nil];
    [((CartPopViewController *)self.popupViewController).closeCart addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    self.checkoutButton.enabled = NO;
  
  
}

- (void)dismissPopup {
    self.tableView.userInteractionEnabled = YES;
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
        self.checkoutButton.enabled = YES;
    }
}

-(void)clearCurrentOrder
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cancel Order", @"Cancel Order") message:NSLocalizedString(@"Are you sure you want to cancel your order?", @"Are you sure you want to cancel your order?") delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
  [alert show];
  NSLog(@"should present a popup");
  alert.tag = 100;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(alertView.tag == 100)
  {
    if(buttonIndex == 0)
    {
      NSLog(@"User wants to stay");
      [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    else
    {
      NSLog(@"user clicked yes and wants to return to locations");
      [globalArrayOrderItems removeAllObjects];
      [globalArrayModifiers removeAllObjects];
      globalCurrentItem  = nil;
      
      [alertView dismissWithClickedButtonIndex:1 animated:YES];
      [self.navigationController popViewControllerAnimated:YES];
    }
  }
  
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}

- (void)didSelectLeafRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedItemIndexPath =[self.tableView indexPathForSelectedRow];
  globalCurrentItem = self.menu[selectedItemIndexPath.section][selectedItemIndexPath.row];
}
@end
