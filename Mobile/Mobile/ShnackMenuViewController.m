//
//  ShnackMenuViewController.m
//  shnack-shnack
//
//  Created by Anshul Jain on 2/22/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import "ShnackMenuViewController.h"
#import "Item.h"
#import "ShnackOrderItemCell.h"
#import "ShnackOrderTotalCell.h"
#import "ObjectWithNameAndID.h"


@interface ShnackMenuViewController ()

@end
int myCount;

@implementation ShnackMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.menu = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
    NSLog(@"viewdidload");//
    self.responseData = [NSMutableData data];//

    
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:3000/api/get_menu_for_vendor?object_id=%d",
                     [globalArrayVendor[selectedVendorRow] object_id]];
    NSString *api_key = [NSString stringWithFormat:@"Token token=\"b2c70bb5d8d2bb35b6b4fcfbc9043d6a\""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
    [request setHTTPMethod:@"GET"];
    
    [request setValue:api_key forHTTPHeaderField:@"Authorization"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];//
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //NSLog(@"didReceiveData");
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
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"my JSON: %@",res);
    self.menu = [[NSMutableArray alloc] initWithCapacity:[res count]];
    for(NSDictionary *item in res)
    {
        int price = [[item objectForKey:@"price"] integerValue];
        NSString *name = [item valueForKey:@"name"];
        Item *item = [[Item alloc] initWithName:name andPrice:price];
        NSLog(@"\nMenu : %@", self.menu);
        [self.menu addObject: item];
    }
    myCount = [self.menu count];
    for (int i=0; i<myCount;i++)
    {
        NSLog(@"\nMenu : %@", [self.menu[i] name]);
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return [self.menu count];
    else
        return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"ItemCell";
        ShnackOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Item *item = self.menu[indexPath.row];
        
        cell.name.text = item.name;
        cell.price.text = [NSString stringWithFormat:@"$%d.%02d", item.price/100, item.price%100];
        cell.count.text = [NSString stringWithFormat:@"%d", item.count];
        
        [cell.plusButton addTarget:self action:@selector(increaseCountByOne:) forControlEvents:UIControlEventTouchDown];
        [cell.minusButton addTarget:self action:@selector(decreaseCountByOne:) forControlEvents:UIControlEventTouchDown];
        return cell;
    }
    else if(indexPath.row == 0){
        static NSString *CellIdentifier = @"OrderTotal";
        ShnackOrderTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        int total = [self calculateOrderTotal];
        NSLog(@"total = %d", total);
        cell.total.text = [NSString stringWithFormat:@"$%d.%02d", total/100, total%100];
        
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"PlaceOrder";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
}


-(int)calculateOrderTotal
{
    int total = 0;
    for (Item *i in self.menu) {
        total += i.price * i.count;
    }

    return total;
}

-(IBAction)increaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    Item *item = self.menu[indexPath.row];
    item.count++;
    
    [self.tableView reloadData];
    
}
-(IBAction)decreaseCountByOne:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    Item *item = self.menu[indexPath.row];
    if(item.count > 0)
    {
        item.count--;
    }
    
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
