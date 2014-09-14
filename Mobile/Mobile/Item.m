//
//  Item.m
//  shnack-shnack
//
//  Created by Anshul Jain on 2/22/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id)initWithName:(NSString *)name andPrice:(int)price
{
    self = [super init];
    if(self) {
        //Initialize
        self.name = name;
        self.price = price;
        self.count = 0;
        
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if(copy)
    {
        [copy setName:[self.name copyWithZone:zone]];
        [copy setPrice:self.price];
        [copy setDescription:self.description];
    }
    return copy;
}
-(id)initWithName:(NSString *)name andCount:(int)count
{
        self = [super init];
        if(self) {
                //Initialize
                self.name = name;
                self.price = 0;
                self.count = count;
        
            }
        return self;
}
-(id)initWithName:(NSString *)name  andPrice:(int)price andDescription:(NSString *)description andModifiers:(NSMutableDictionary *)modifiers
{
    self = [super init];
    if(self) {
        //Initialize
        self.name = name;
        self.price = price;
        self.count = 0;
        self.description = description ;
        self.modifiers =  modifiers;
        
    }
    return self;
}

@end
