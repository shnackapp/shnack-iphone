//
//  OpenOrderTableViewCell.h
//  Shnack
//
//  Created by Spencer Neste on 10/30/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenOrderTableViewCell : UITableViewCell


@property (nonatomic,retain)  IBOutlet UILabel *quantity;

@property (nonatomic,retain)  IBOutlet UILabel *item_name;
@property (nonatomic,retain)  IBOutlet UILabel *item_price;

@property (nonatomic,retain)  IBOutlet UILabel *modifier_name;

@property (nonatomic,retain)  IBOutlet UILabel *option_name;
@property (nonatomic,retain)  IBOutlet UILabel *option_price;





@end
