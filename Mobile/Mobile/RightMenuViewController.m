//
//  DEMORightMenuViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 2/11/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "RightMenuViewController.h"
#import "SecondViewController.h"
#import "LeftMenuViewController.h"

#define NUMBER_OF_ITEMS 4
@interface RightMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation RightMenuViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * NUMBER_OF_ITEMS) / 2.0f, self.view.frame.size.width, 54 * NUMBER_OF_ITEMS) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            case 0: {
            /*[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"stadiumViewController"]]
                                                         animated:YES];*/
            
            /// use the uinavigationcontroller from our storyboard
            [self.sideMenuViewController setContentViewController:[[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            }
            case 1: {
            UINavigationController *navController = [[self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"]];
                [navController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"] animated:NO];
                [navController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"myOrderViewController"] animated:NO];
                [self.sideMenuViewController setContentViewController:navController animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
                    }/*
                case 2: {[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
                      }*/
        default: { break;
        }
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
    return NUMBER_OF_ITEMS;
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
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Locations", @"Current Order", @"Past Orders", @"Payment Info"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}

@end
