//
//  ShnackOrderItemCell.h
//  shnack-shnack
//
//  Created by Anshul Jain on 2/22/14.
//  Copyright (c) 2014 Shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPDCell.h"

@interface ShnackOrderItemCell : POPDCell

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) IBOutlet UILabel *description;



@end
