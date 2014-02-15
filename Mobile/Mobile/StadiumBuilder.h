//
//  StadiumBuilder.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StadiumBuilder : NSObject

+ (NSArray *)stadiumsFromJSON:(NSData *)objectNotation error:(NSError **)error;

@end