//
//  Modifier.h
//  Shnack
//
//  Created by Spencer Neste on 10/10/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Modifier : NSObject <NSCopying>

@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger mod_type;
@property (nonatomic) NSMutableArray *options;

-(id)initWithName:(NSString *)name andModType:(NSInteger)mod_type
     andOptions:(NSMutableArray *)options;
@end
