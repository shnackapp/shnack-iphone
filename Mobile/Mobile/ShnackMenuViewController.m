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


@interface ShnackMenuViewController ()  <POPDDelegate>
@property (nonatomic) NSInteger vendorID;
@end
NSInteger myCount;

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
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    globalCurrentVendorName = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] name];
    NSLog(@"top name %@",globalCurrentVendorName);
    //self.navigationItem.title = globalCurrentVendorName;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
    
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = globalCurrentVendorName;
    [label sizeToFit];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];// so you can dismiss on click!
    //[self.tableView addGestureRecognizer:tapRecognizer];
    
    self.useBlurForPopup = YES;

    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //self.tableView.delegate = self;
    self.tableView.popDownDelegate = self;
    //self.tableView.dataSource = self;
    
    [[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
    [self.checkoutButton setStyle:BButtonStyleBootstrapV3];
    [self.checkoutButton setType:BButtonTypeFacebook];
    [self.checkoutButton addTarget:self action:@selector(presentCart) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated {
    if (selectedIndexPath == nil) {
        self.checkoutButton.enabled = NO;
    } else {
        self.checkoutButton.enabled = YES;
        
        globalCurrentVendorID = [globalArrayLocations[selectedIndexPath.section][selectedIndexPath.row] object_id];

        if (globalCurrentVendorID != globalOpenOrderVendorID) {
            self.responseData = [NSMutableData data];
            NSString *url = [NSString stringWithFormat:@"%@/get_menu_for_vendor?object_id=%d", BASE_URL,globalCurrentVendorID];
            NSString *api_key = [NSString stringWithFormat:API_KEY];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            [request setValue:api_key forHTTPHeaderField:@"Authorization"];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
        } else {
            self.menu = globalOpenOrderMenu;
            NSMutableArray *tableData = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < [self.menu count]; i++)
            {
                NSArray *category = self.menu[i];
                Item *categoryItem = category[0];
                NSString *categoryName = categoryItem.name;
                NSMutableArray *tableSection = [[NSMutableArray alloc] init];
                for (NSInteger j = 1; j < [category count]; j++)
                {
                    Item *item = category[j];
                    [tableSection addObject:item.name];
                }
                NSDictionary *section = [NSDictionary dictionaryWithObjectsAndKeys:categoryName,POPDCategoryTitleTV,tableSection, POPDSubSectionTV,nil];
                [tableData addObject:section];
            }
            [self.tableView setMenuSections:tableData];

        }
        
        NSInteger total = [self calculateOrderTotal];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    }
    
    

    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:animated];
        [self.tableView reloadData];
        NSInteger total = [self calculateOrderTotal];
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
    

}



//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if(indexPath.row == 0)
//    {
//        return 60.0f;
//    }
//    
//    else
//    {
//        return 100.0f;
//    }
//}

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
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    NSError *myError = nil;
  ////////
  
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    //NSLog(@"my JSON: %@",res);
    NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:[res count]];
    self.menu = [[NSMutableArray alloc] initWithCapacity:[res count]];
  
  for(NSDictionary *category in [res valueForKey:@"categories"])
    {
      NSArray *items = [category objectForKey:@"items"];
      NSString *categoryName = [category objectForKey:@"name"];
      
      NSMutableArray *menuCategory = [[NSMutableArray alloc] initWithCapacity:[items count]];
      NSMutableArray *tableSection = [[NSMutableArray alloc] initWithCapacity:[items count]];
      
      NSLog(@"cat_name: %@", categoryName);
      NSLog(@"menu_category: %lu", (unsigned long)[items count]);
      Item *categoryItem = [[Item alloc] initWithName:categoryName andCount:0];
      [menuCategory addObject:categoryItem];
      NSLog(@"LOOOOOK HERE! %@",categoryItem.name);
        
        for(NSDictionary *item in items)
        {
            NSInteger price = [[item objectForKey:@"price"] integerValue];
            NSString *name = [item  objectForKey:@"name"];
            NSString *description = [[item objectForKey:@"description" ] isKindOfClass:[NSNull class]] ? @"No Description" : [item objectForKey:@"description"];
            NSLog(@"name %@",name);
            NSLog(@"price %ld",(long)price);
            NSLog(@"description1 %@",description);
            NSLog(@"description2 %@",[item objectForKey:@"description"]);
            NSMutableDictionary *mods = [item objectForKey:@"modifiers" ];
            NSLog(@"mods: %@", mods);
            NSInteger count = [mods count];
            bool is_empty;
            if(count == 0) is_empty=true;
            else is_empty = false;
            NSLog(@"mods is_empty %@", is_empty ? @YES:@NO);
//            NSMutableDictionary *stored_mods = is_empty ? NULL :
//            [[NSMutableDictionary alloc] initWithCapacity:[mods count]];
//            for(NSDictionary * modifier in mods)
//            {
//              NSInteger mod_type = [[modifier objectForKey:@"mod_type"] integerValue];
//              NSString *name = [modifier objectForKey:@"name"];
//              NSDictionary *options = [modifier objectForKey:@"options"];
//              for(NSDictionary *option in options)
//              {
//                NSString *option_name = [option objectForKey:@"name"];
//                NSInteger option_price = [option objectForKey:@"price"];
//              }
//
//              
//            }
          
            Item *new_item = [[Item alloc] initWithName:name andPrice:price andDescription:description andModifiers:mods];
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
    
    [self.tableView setMenuSections:tableData];
    [self.tableView reloadData];
////////
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

    
//    itemCell.count.text = [NSString stringWithFormat:@"%d", item.count];
//    
//    [itemCell.plusButton addTarget:self action:@selector(increaseCountByOne:) forControlEvents:UIControlEventTouchDown];
//    [itemCell.minusButton addTarget:self action:@selector(decreaseCountByOne:) forControlEvents:UIControlEventTouchDown];
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
    NSInteger categoryCount = ((Item *)self.menu[indexPath.section][0]).count;
    ShnackOrderCategoryCell *categoryCell = (ShnackOrderCategoryCell *)cell;
    if (categoryCount == 0) {
        categoryCell.count.hidden = YES;
    } else {
        categoryCell.count.hidden = NO;
        categoryCell.count.text = [NSString stringWithFormat:@"%ld", (long)categoryCount];
    }
    categoryCell.labelText.text = ((Item *)self.menu[indexPath.section][0]).name;
}


-(NSInteger)calculateOrderTotal
{
    NSInteger total = 0;
    for (NSArray *category in self.menu) {
        for (NSInteger i = 1; i < [category count]; i++) {
            total += ((Item *)category[i]).price * ((Item *)category[i]).count;
        }
    }
    
    return total;
}


//-(IBAction)increaseCountByOne:(id)sender
//{
//
//    if (globalOpenOrderMenu != self.menu) {
//        globalOpenOrderMenu = self.menu;
//        globalOpenOrderVendorID = globalCurrentVendorID;
//        globalOpenOrderVendorName = globalCurrentVendorName;
//    }
//    
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
//    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//    Item *categoryItem = self.menu[indexPath.section][0];
//    Item *item = self.menu[indexPath.section][indexPath.row];
//    item.count++;
//    categoryItem.count++;
//    
//    NSInteger total = [self calculateOrderTotal];
//    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    
//}
//-(IBAction)decreaseCountByOne:(id)sender
//{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
//    NSIndexPath *categoryIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
//    
//    Item *categoryItem = self.menu[indexPath.section][0];
//    Item *item = self.menu[indexPath.section][indexPath.row];
//    if(item.count > 0)
//    {
//        categoryItem.count--;
//        item.count--;
//    }
//    NSInteger total = [self calculateOrderTotal];
//    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    
//}

-(IBAction)presentCart
{
    NSLog(@"I PRESSED IT!");
    self.tableView.userInteractionEnabled = NO;//so the view behind popup is disabled
    
    CartPopViewController *cart = [[CartPopViewController alloc] initWithNibName:@"CartPopViewController" bundle:nil];
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
//    tapRecognizer.numberOfTapsRequired = 1;
    
    [self presentPopupViewController:cart animated:YES completion:nil];
    //tap tableview to dismiss
    //tapRecognizer.delegate = self.tableView;
    //[self.tableView addGestureRecognizer:tapRecognizer];
    
    

    //this dismisses popup!!
    //[((CartPopViewController *)self.popupViewController).closeCart addGestureRecognizer:tapRecognizer];
    [((CartPopViewController *)self.popupViewController).closeCart addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkoutButton.enabled = NO;
    
}

- (void)dismissPopup {
    self.tableView.userInteractionEnabled = YES;
//    CartPopViewController *cart = [[CartPopViewController alloc] initWithNibName:@"CartPopViewController" bundle:nil];
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
//    tapRecognizer.numberOfTapsRequired = 1;
//    tapRecognizer.delegate = self;
    
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            NSLog(@"popup view dismissed");
        }];
        self.checkoutButton.enabled = YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}





@end
