//
//  StadiumBuilder.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
// this class is supposed to build that Stadium Table

#import "StadiumBuilder.h"
#import "Stadium.h"

@implementation StadiumBuilder

+ (NSArray *)stadiumsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *stadiums = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %d", results.count);
    
    for (NSDictionary *stadiumDic in results) {
        Stadium *stadium = [[Stadium alloc] init];
        
        for (NSString *key in stadiumDic) {
            if ([stadium respondsToSelector:NSSelectorFromString(key)]) {
                [stadium setValue:[stadiumDic valueForKey:key] forKey:key];
            }
        }
        
        [stadiums addObject:stadium];
    }
    
    return stadiums;
}
@end