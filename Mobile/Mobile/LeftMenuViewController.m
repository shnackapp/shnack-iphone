//
//  DEMOLeftMenuViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "AccountTableViewController.h"


@interface LeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 4) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = YES;
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
//            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"accountViewController"]]
//                                                         animated:YES];
//
            
//            [self.sideMenuViewController setContentViewController:(AccountViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"test"]  animated:YES];
            
            [self.sideMenuViewController setContentTableViewController:(AccountTableViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"table_test"]  animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];            break;
        case 2:
            
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        case 3:
            
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
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor greenColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
   
    NSArray *titles = @[@"Account", @"Settings", @"Past Orders", @"Payment Info"];
    NSArray *images = @[@"IconHome", @"IconSettings", @"IconCalendar", @"IconProfile"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}

@end
