//
//  main.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

UINavigationController *navigationController;

int main(int argc, char * argv[])
{
    int retVal = -1;
    @autoreleasepool {
        @try {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException* exception) {
            NSLog(@"Uncaught exception: %@", exception.description);
            NSLog(@"Stack trace: %@", [exception callStackSymbols]);
        }
    }
    return retVal;
    
    //@autoreleasepool {
    //    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    //}
}
