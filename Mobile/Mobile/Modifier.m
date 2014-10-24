//
//  Modifier.m
//  Shnack
//
//  Created by Spencer Neste on 10/10/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "Modifier.h"

@implementation Modifier

-(id)initWithName:(NSString *)name andModType:(NSInteger)mod_type
       andOptions:(NSMutableArray *)options
{
  self = [super init];
  
  self.name = name;
  self.mod_type = mod_type;
  self.options = options;
  return self;
}

//-(id)copyWithZone:(NSZone *)zone
//{
//  id copy = [[[self class] alloc] init];
//  
//  if(copy)
//  {
//    [copy setName:[self.name copyWithZone:zone]];
//    [copy setType:self.mod_type];
//    [copy setOptions:self.description];
//  }
//  return copy;
//}


@end
