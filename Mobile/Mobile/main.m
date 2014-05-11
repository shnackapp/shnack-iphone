//
//  main.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MainPageViewController.h"


NSMutableArray *globalArrayLocations = nil;
NSIndexPath *selectedIndexPath = nil;
NSMutableArray *globalOpenOrderMenu = nil;
NSInteger globalOpenOrderVendorID = -1;
NSInteger globalCurrentVendorID = -1;
NSString *globalOpenOrderVendorName = nil;
NSString *globalCurrentVendorName = nil;
MainPageViewController *mainPages = nil;



int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
