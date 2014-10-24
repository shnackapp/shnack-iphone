//
//  Order.m
//  Shnack
//
//  Created by Spencer Neste on 10/18/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "Order.h"

@implementation Order

-(id)initWithName:(NSInteger)total
        andUserID:(NSInteger)user_id
        andVendorID:(NSInteger)vendor_id
        andItems:(NSMutableDictionary *)items {
  
  self = [super init];
  self.user_id = user_id;
  self.total = total;
  self.items = items;
  self.vendor_id = vendor_id;
  
  return self;
}


@end
