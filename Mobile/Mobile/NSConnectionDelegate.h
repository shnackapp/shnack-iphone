//
//  NSConnectionDelegate.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSConnectionDelegate : NSObject
@property (strong,nonatomic) NSString *usernameField;
@property (strong,nonatomic) NSString *passwordField;

@property (strong,nonatomic) NSData *receivedData;

-(IBAction)login:(id)sender;

@end
