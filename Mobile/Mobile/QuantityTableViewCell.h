//
//  QuantityTableViewCell.h
//  Shnack
//
//  Created by Spencer Neste on 10/2/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BButton.h"

@interface QuantityTableViewCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel *quantity;
@property (nonatomic,retain) IBOutlet UILabel *title;
@property IBOutlet BButton *minusButton;
@property IBOutlet BButton *plusButton;

@end
