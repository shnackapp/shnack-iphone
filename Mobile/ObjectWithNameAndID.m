//
//  ObjectWithNameAndID.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ObjectWithNameAndID.h"

@implementation ObjectWithNameAndID

-(id)initWithID:(int)num name:(NSString *)name
{
    self = [super init];
    if(self) {
        //initialize
        self.object_id = num;
        self.name = name;
        
    }
    return self;
}

@end