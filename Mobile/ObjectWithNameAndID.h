//
//  ObjectWithNameAndID.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectWithNameAndID : NSObject

@property (nonatomic) int object_id;
@property (nonatomic) NSString *name;

- (id)initWithID:(int)num name:(NSString *)name;

@end