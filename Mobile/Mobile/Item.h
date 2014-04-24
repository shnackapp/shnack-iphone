//
//  Item.h
//  shnack-shnack
//
//  Created by Anshul Jain on 2/22/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCopying>

@property (nonatomic, retain) NSString *name;
@property (nonatomic) int price;
@property (nonatomic) int count; //Quantity Ordered Count -- see bottom

-(id)initWithName:(NSString *)name andPrice:(int)price;
-(id)initWithName:(NSString *)name andCount:(int)count;


@end


/* 
Quantity ordered count was placed in this class because the NSDictionary in the ShnackMenuViewController was not updating correctly and I couldnt' figure out why, and I couldn't come up with a reason that putting it here would cause problems. If you're looking at this in the future and it turns out that it is causing problems, deprecate this and do it a better way please!
*/