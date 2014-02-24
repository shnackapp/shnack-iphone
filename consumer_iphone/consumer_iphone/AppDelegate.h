//
//  VendorAppDelegate.h
//  Vendor
//
//  Created by Anshul Jain on 2/1/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StadiumViewController.h"

@interface StadiumAppDelegate : UIResponder <UIApplicationDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *deviceToken;


-(void)sendDeviceTokenToDatabase:(NSData *)token;
-(void)initializeOrdersForStadiumViewController:(StadiumViewController *)stadiumViewController;


@end
