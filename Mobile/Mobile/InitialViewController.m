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
<<<<<<< HEAD
    self.signUp.hidden = true;
    self.orderNow.hidden = true;
    self.Login.hidden = true;
    
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    
    self.signUp.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    self.orderNow.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    self.Login.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:20];
    
    
<<<<<<< HEAD
    _swipe = @[@"Swipe up",@"",@"",@""];
    _swipeBlurb = @[@"Shnack. You're Order Is Ready.",@"",@"",@""];

    _pageTitles = @[ @"",@"From your seat, view the menus of vendors. Pay and place your order.", @"Sit back, relax, and enjoy the experience.", @"When your order is ready, a notification will be sent. Pick up and enjoy."];
     _TopTitles = @[ @"Shnack",@"Order", @"Relax", @"Pick Up"];
    _pageImages = @[@"upArrow.png",@"logo.png", @"logo.png", @"logo.png"];    // Create page view controller
=======
    
    _pageTitles = @[ @"From your seat, view the menus of vendors. Pay and place your order.", @"Sit back, relax, and enjoy the experience.", @"When your order is ready, a notification will be sent. Pick up and enjoy."];
     _TopTitles = @[ @"Order", @"Relax", @"Pick Up"];
    _pageImages = @[@"logo.png", @"logo.png", @"logo.png"];    // Create page view controller
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TutorialContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
<<<<<<< HEAD
    
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.view sendSubviewToBack:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

<<<<<<< HEAD
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
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
<<<<<<< HEAD
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

    
    


=======
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutorialContentViewController*) viewController).pageIndex;
<<<<<<< HEAD


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

=======
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    return [self viewControllerAtIndex:index];
}

- (TutorialContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
<<<<<<< HEAD
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

=======
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    // Create a new view controller and pass suitable data.
    TutorialContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.TopText = self.TopTitles[index];
<<<<<<< HEAD
    
    pageContentViewController.blurbText = self.pageTitles[index];
    pageContentViewController.swipeLabelText = self.swipe[index];
    pageContentViewController.brandLabelText = self.swipeBlurb[index];
   
=======
    pageContentViewController.blurbText = self.pageTitles[index];
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

<<<<<<< HEAD

=======
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

@end
