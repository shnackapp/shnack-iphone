//
//  DetailViewController.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "VendorViewController.h"
#import "StadiumViewController.h"

#import "ObjectWithNameAndID.h"
#import "VendorCell.h"



@interface VendorViewController ()
- (void)configureView;
@end

int myCount;


@implementation VendorViewController

#pragma mark - Managing the Vendor item

- (void)setVendorItem:(id)newVendorItem
{
    if (_vendorItem != newVendorItem) {
        _vendorItem = newVendorItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.vendorItem) {
        self.vendorDescriptionLabel.text = [[self.vendorItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [super viewDidLoad];
        //NSLog(@"viewdidload");//
        self.responseData = [NSMutableData data];//
        //NSLog(@"response data is %@",self.responseData);
    NSInteger row = [self.tableView indexPathForSelectedRow].row;
    //NSLog(@"This is row num %ld",(long)row);
    
        NSString *url =
    [NSString stringWithFormat:@"http://127.0.0.1:3000/api/get_vendor_for_location?object_id=%d",[globalArray[selectedRow] object_id]];
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
    //NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connectionDidFinishLoading");
    //NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    NSError *myError = nil;

    
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    self.vendors = [[NSMutableArray alloc] initWithCapacity:[res count]];

    for(NSDictionary *vendor in res)
    {
        int id_ = [[vendor objectForKey:@"id"] integerValue];
        NSString *name = [vendor valueForKey:@"name"];
        ObjectWithNameAndID *aVendor = [[ObjectWithNameAndID alloc] initWithID:id_ name:name];
        //aVendor.object_id=id_;
        //aVendor.name=name;
        [self.vendors addObject: aVendor];
    }
    myCount = [self.vendors count];
    for (int i=0; i<myCount;i++)
    {
    NSLog(@"\nVendor ID: %d \nVendor Name: %@", [self.vendors[i] object_id],[self.vendors[i] name]);
    }
    
    myCount = [self.vendors count];
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //NSLog(@" number of rows is %lu",(unsigned long) myCount);
    return [self.vendors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VendorCell";
    VendorCell *cell = (VendorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.vendorName.text = [self.vendors[indexPath.row] name];
    //UIFont *newFont = [UIFont fontWithName:@"PoiretOne-Regular" size:20];
    //[cell.stadiumName setFont:newFont];
    
    return cell;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
