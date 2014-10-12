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
NSMutableArray *globalUserInfo = nil;
NSMutableArray *globalCurrentUser = nil;
NSMutableDictionary *fb_user_info = nil;
NSMutableDictionary *shnack_user_info = nil;
NSMutableDictionary *global_menu = nil;
NSMutableArray *global_item_menu = nil;


BOOL uses_keychain = NO;
BOOL uses_facebook = NO;


MainPageViewController *mainPages = nil;
int *globalCurrentOrderAmount = 0;



int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
