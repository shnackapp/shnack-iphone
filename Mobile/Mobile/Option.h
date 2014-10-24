//
//  Option.h
//  Shnack
//
//  Created by Spencer Neste on 10/10/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger price;

@property (nonatomic) BOOL isOn;

-(id)initWithName:(NSString *)name andPrice:(NSInteger)price;

@end
