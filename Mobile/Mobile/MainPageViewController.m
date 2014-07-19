////
////  MainPageViewController.m
////  Mobile
////
////  Created by Spencer Neste on 5/10/14.
////  Copyright (c) 2014 shnack. All rights reserved.
////
//
//#import "MainPageViewController.h"
//
//@interface MainPageViewController ()
//
//@end
//
//@implementation MainPageViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    mainPages = self;
//    self.dataSource = self;
//    
//    self.pages = @[
//        [self.storyboard instantiateViewControllerWithIdentifier:@"locationsViewController"],
//        [self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"],
//        [self.storyboard instantiateViewControllerWithIdentifier:@"myOrderViewController"]
//    ];
//    [self setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//    
//    
//    self.pageIndices = [[NSMutableDictionary alloc] initWithCapacity:[self.pages count]];
//    NSInteger index = 0;
//    for (UIViewController *viewController in self.pages) {
//        [self.pageIndices setObject:[NSNumber numberWithInteger:index] forKey:[NSValue valueWithNonretainedObject:viewController]];
//        index++;
//    }
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
//{
//    NSInteger index = ((NSNumber *)[self.pageIndices objectForKey:[NSValue valueWithNonretainedObject:viewController]]).intValue;
//    
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
//    
//    index--;
//    
//    return [self viewControllerAtIndex:index];
//}
//
//- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
//{
//    NSInteger index = ((NSNumber *)[self.pageIndices objectForKey:[NSValue valueWithNonretainedObject:viewController]]).intValue;
//    
//    
//    if (index == NSNotFound) {
//        return nil;
//    }
//    
//    index++;
//    
//    if (index == [self.pages count]) {
//        return nil;
//    }
//    
//    return [self viewControllerAtIndex:index];
//}
//
//
//- (UIViewController *) viewControllerAtIndex:(NSUInteger)index
//{
//    if (([self.pages count] == 0) || (index >= [self.pages count])) {
//        return nil;
//    }
//    
//    return self.pages[index];
//}
//
////-(UIViewController *) nextViewController {
////    return self.pages[index+1];
////
////}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
