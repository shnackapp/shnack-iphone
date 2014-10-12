//
//  Option.m
//  Shnack
//
//  Created by Spencer Neste on 10/10/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "Option.h"

@implementation Option

-(id)initWithName:(NSString *)name andPrice:(int)price
{
  self = [super init];
  
  self.name = name;
  self.price = price;
  return self;
}
@end
