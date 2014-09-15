//
//  StadiumViewController.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LocationsViewController.h"
#import "ObjectWithNameAndID.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "POPDCell.h"
#import "NSObject_Constants.h"
#import "LoginContainerViewController.h"



@interface LocationsViewController () <POPDDelegate>
@end

@implementation LocationsViewController

NSIndexPath *reloadingCategoryIndexPath;


- (void)viewDidLoad
{
        
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    //disable swipe back in nav controller
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
    
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Locations", @"");
    [label sizeToFit];
    
    self.delegate = self;
    self.tableView.dataSource = self;
    [super viewDidLoad];
    self.responseData = [NSMutableData data];//
   
    self.navigationItem.hidesBackButton = YES;
    
    NSString *url = [NSString stringWithFormat:@"%@/get_locations",BASE_URL];
    NSString *api_key = [NSString stringWithFormat:API_KEY];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
    [request setHTTPMethod:@"GET"];
    
    [request setValue:api_key forHTTPHeaderField:@"Authorization"];
    
    [self setLoading:YES];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    
    self.sideMenuViewController.panGestureEnabled = YES;
}

-(void)infoButtonAction
{
    NSLog(@" pressed the i");

}
//////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSString *url = [[[connection currentRequest] URL] lastPathComponent];
    NSError *myError = nil;
    
    
    if ([url compare:@"get_locations"] == NSOrderedSame) {
        NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        self.locations = [[NSMutableArray alloc] initWithCapacity:[res count]];
        
        NSLog(@"%@", [res description]);
        
        NSMutableArray *menu = [[NSMutableArray alloc] initWithCapacity:[res count]];
        for(NSDictionary *stadium in res)
        {
            int id_ = [[stadium objectForKey:@"id"] integerValue];
            NSString *name = [stadium valueForKey:@"name"];
            BOOL hasChildren = [[stadium valueForKey:@"has_children"] boolValue];
            
            ObjectWithNameAndID *aStadium = [[ObjectWithNameAndID alloc] initWithID:id_ name:name];
            
            
            NSDictionary *section;
            if (hasChildren) {
                section = [NSDictionary dictionaryWithObjectsAndKeys:
                                    name, POPDCategoryTitle,
                                    [[NSArray alloc] init], POPDSubSection,
                                    nil];
                [self.locations addObject:aStadium];
            } else {
                section = [NSDictionary dictionaryWithObjectsAndKeys:
                                        name, POPDCategoryTitle,
                                        nil, POPDSubSection,
                                        nil];
                [self.locations addObject: [NSArray arrayWithObjects:aStadium,nil]];
            }
            [menu addObject:section];
        }
        
        globalArrayLocations = self.locations;
        [self setMenuSections:menu];
        [self setLoading:NO];
    }
    else {
        NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
        NSMutableArray *vendors = [[NSMutableArray alloc] initWithCapacity:[res count]];
        [vendors addObject:[self.locations objectAtIndex:reloadingCategoryIndexPath.section]];
        
        NSLog(@"%@", [res description]);
        
        NSMutableArray *sectionChildren = [[NSMutableArray alloc] initWithCapacity:[res count]+1];
        for(NSDictionary *stadium in res)
        {
            int id_ = [[stadium objectForKey:@"id"] integerValue];
            NSString *name = [stadium valueForKey:@"name"];
            
                       
            ObjectWithNameAndID *aStadium = [[ObjectWithNameAndID alloc] initWithID:id_ name:name];
            [vendors addObject: aStadium];

            [sectionChildren addObject:name];
        }
        [self.locations replaceObjectAtIndex:reloadingCategoryIndexPath.section withObject:vendors];

        [self setMenuSectionChildren:sectionChildren atSection:reloadingCategoryIndexPath.section];

        POPDCell *cell = (POPDCell *)[self.tableView cellForRowAtIndexPath:reloadingCategoryIndexPath];
        [cell.indicator stopAnimating];
    }
}


- (void)viewDidUnload {

    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table View

- (void)didSelectCategoryRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"------->row selected %ld", (long)indexPath.row);
    
    if (![[self.locations objectAtIndex:indexPath.section] isKindOfClass:[NSArray class]]) {
        reloadingCategoryIndexPath = indexPath;
        
        POPDCell *cell = (POPDCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.indicator startAnimating];
        
        
        NSString *url = [NSString stringWithFormat:@"%@/get_vendor_for_location?object_id=%d",BASE_URL,[globalArrayLocations[indexPath.section] object_id]];
    
        NSString *api_key = [NSString stringWithFormat:API_KEY];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
        [request setHTTPMethod:@"GET"];
        [request setValue:api_key forHTTPHeaderField:@"Authorization"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
    }
}

- (void)didSelectLeafRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECTED LEAF ROW!@@!!");
    selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    //move the page view controller to next page..
    


}






#pragma mark - Fetched results controller


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


@end
