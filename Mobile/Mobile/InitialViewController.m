//
//  InitialViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/8/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "InitialViewController.h"
#import "AppDelegate.h"
#import "LocationsViewController.h"

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
    self.did_skip_initial = NO;
    [super viewDidLoad];
    
    self.signUp.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    self.orderNow.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    self.Login.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    
    
    _swipe = @[@"Swipe up",@"",@"",@""];
    _swipeBlurb = @[@"Shnack. You're Order Is Ready.",@"",@"",@""];

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
    //[self.view addSubview:_dots];
    
   
    if ((index == 0) || (index == NSNotFound)) {
        return nil;

    }
   // _dots.currentPage = index;
    
    
    BOOL result1 = [@"Shnack" isEqualToString:self.TopTitles[index]];
    if (result1)
    {
        _dots.hidden = YES;
        _dots.currentPage = 0;
        NSLog(@"Setting current Page to 0 in before");
        NSLog(@"Only On Shnack %lu: %@", (unsigned long)index,self.TopTitles[index]);
        self.signUp.hidden = true;
        self.orderNow.hidden = true;
        self.Login.hidden = true;
        self.topBar.hidden = true;
    }
    if (!result1)
    {
        _dots.hidden = NO;
        //if not on swipe page, show buttons and image bar,
        self.signUp.hidden = false;
        self.orderNow.hidden = false;
        self.Login.hidden = false;
        self.topBar.hidden = false;
        
    }


    
    
//
    index--;

    NSLog(@"B.Current page %lu",(unsigned long)index);

    
    


    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;


    if (index == NSNotFound) {
        return nil;
    }
    //_dots.currentPage = index;

   
    index++;
    NSLog(@"A.Current page %lu",(unsigned long)index);

     //[self.view addSubview:_dots];
    
    if (index == [self.pageTitles count]) {
        NSLog(@"index == 4 At end");
//        return nil;
    }

    return [self viewControllerAtIndex:index];
}

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    _dots = [[UIPageControl alloc] init];
    _dots.contentVerticalAlignment = YES;
    _dots.transform = CGAffineTransformMakeRotation(M_PI_2);
    _dots.frame = CGRectMake(300, 375, 15, 75);
    _dots.numberOfPages = [self.pageTitles count];
    _dots.backgroundColor = [UIColor lightGrayColor];
    _dots.currentPageIndicatorTintColor = [UIColor colorWithRed:153 green:0 blue:0 alpha:1.0];
    _dots.pageIndicatorTintColor = [UIColor blackColor];
    if(index == 0){NSLog(@"C.cp = 0");_dots.currentPage = index;}
    else          {_dots.currentPage = index-1;}

    NSLog(@"C.Current page %lu", (unsigned long)_dots.currentPage);

    
//    if (index == 0){_dots.currentPage = index-1;}
//    if (index == 1){_dots.currentPage = index-1;}
//    if (index == 2){_dots.currentPage = index-1;}
//    if (index == 3){_dots.currentPage = index-1;}
    [self.view addSubview:_dots];


    
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    TutorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.TopText = self.TopTitles[index];
    
    pageContentViewController.blurbText = self.pageTitles[index];
    pageContentViewController.swipeLabelText = self.swipe[index];
    pageContentViewController.brandLabelText = self.swipeBlurb[index];
   
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}



@end
