//
//  InitialViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/8/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

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
    
    [super viewDidLoad];
    
    self.signUp.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    self.orderNow.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    self.Login.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    
    
    _swipeUp = @[@"Swipe up",@"",@"",@""];
    _swipeUpBlurb = @[@"Shnack. You're Order Is Ready.",@"",@"",@""];

    _pageTitles = @[ @"",@"From your seat, view the menus of vendors. Pay and place your order.", @"Sit back, relax, and enjoy the experience.", @"When your order is ready, a notification will be sent. Pick up and enjoy."];
     _TopTitles = @[ @"Shnack",@"Order", @"Relax", @"Pick Up"];
    _pageImages = @[@"upArrow.png",@"logo.png", @"logo.png", @"logo.png"];    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.view sendSubviewToBack:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
 
    NSLog(@"Before up %lu: %@", (unsigned long)index,self.TopTitles[index]);

    index--;

    NSLog(@"After up %lu: %@", (unsigned long)index,self.TopTitles[index]);

    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    NSLog(@"before swiping down %lu: %@", (unsigned long)index,self.TopTitles[index]);

    index++;
    
    if (index == [self.pageTitles count]) {
        return nil;
    }
    NSLog(@"after swiping down %lu: %@", (unsigned long)index,self.TopTitles[index]);

    return [self viewControllerAtIndex:index];
}

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
//    BOOL result = [@"Shnack" isEqualToString:self.TopTitles[index]];
//    if(result)
//    {
//        NSLog(@"Current View Index %lu: %@", (unsigned long)index,self.TopTitles[index]);
//        self.signUp.hidden = true;
//        self.orderNow.hidden = true;
//        self.Login.hidden = true;
//        self.topBar.hidden = true;
//    }
//    if (!result)
//    {
//        NSLog(@"View Controller at Index %lu: %@", (unsigned long)index,self.TopTitles[index]);
//        //if not on swipe page, show buttons and image bar,
//        self.signUp.hidden = false;
//        self.orderNow.hidden = false;
//        self.Login.hidden = false;
//        self.topBar.hidden = false;
//        
//    }
//    
    
   
    // Create a new view controller and pass suitable data.
    TutorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.TopText = self.TopTitles[index];
    
//    if (index == 0)
//    {
//        NSString *temp;
//        temp = self.TopTitles[index];
//        //temp = [UIFont fontWithName:@"Damion" size:40 ];
//        pageContentViewController.TopLabel.font = [UIFont fontWithName:@"Poiret One" size:40 ];
//        pageContentViewController.TopText = temp;
//    }
    pageContentViewController.blurbText = self.pageTitles[index];
    pageContentViewController.swipeLabelText = self.swipeUp[index];
    pageContentViewController.brandLabelText = self.swipeUpBlurb[index];
    BOOL result1 = [@"Shnack" isEqualToString:self.TopTitles[index]];
    if (result1)
    {
    NSLog(@"Only On Shnack %lu: %@", (unsigned long)index,self.TopTitles[index]);
        self.signUp.hidden = true;
        self.orderNow.hidden = true;
        self.Login.hidden = true;
        self.topBar.hidden = true;
    }
    if (!result1)
    {
        NSLog(@"View Controller at Index %lu: %@", (unsigned long)index,self.TopTitles[index]);
        //if not on swipe page, show buttons and image bar,
        self.signUp.hidden = false;
        self.orderNow.hidden = false;
        self.Login.hidden = false;
        self.topBar.hidden = false;
        
    }
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}



@end
