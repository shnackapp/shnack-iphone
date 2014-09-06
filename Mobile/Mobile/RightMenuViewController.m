//
//  DEMORightMenuViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 2/11/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "RightMenuViewController.h"
#import "LeftMenuViewController.h"

@interface RightMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation RightMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 54 , self.view.frame.size.width, 54 * 4) style:UITableViewStylePlain ];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // tableView.separatorColor = [UIColor whiteColor];
        tableView.scrollEnabled = YES;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            self.payment_info = YES;NSLog(@"payment_info %i",self.payment_info);
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];            break;
        case 2:
            self.past_orders = YES;NSLog(@"past %i",self.past_orders);
            
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        case 3:
            self.logout = YES;NSLog(@"logut %i",self.logout);
            
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor =  [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor greenColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.textLabel.textColor = self.account_settings? [UIColor greenColor] : [UIColor whiteColor];
    cell.textLabel.textColor = self.payment_info? [UIColor greenColor] : [UIColor whiteColor];
    cell.textLabel.textColor = self.past_orders? [UIColor greenColor] : [UIColor whiteColor];
    cell.textLabel.textColor = self.logout? [UIColor greenColor] : [UIColor whiteColor];
    NSArray *titles = @[@"Account Settings", @"Payment Info", @"Past Orders", @"Logout"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    self.account_settings = NO;
    self.payment_info = NO;
    self.past_orders = NO;
    self.logout = NO;
    
    

    return cell;
}

@end
