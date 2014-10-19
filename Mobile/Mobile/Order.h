//
//  Order.h
//  Shnack
//
//  Created by Spencer Neste on 10/18/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic) NSInteger order_number;
@property (nonatomic) NSInteger user_id;
@property (nonatomic) NSInteger subtotal;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger vendor_id;

@property (nonatomic,retain) NSMutableDictionary *items;
-(id)initWithName:(NSString *)order_number
         andTotal:(NSInteger)total
         andUserID:(NSInteger *)user_id
         andVendorID:(NSInteger)vendor_id
         andItems:(NSMutableDictionary *)items;
@end
