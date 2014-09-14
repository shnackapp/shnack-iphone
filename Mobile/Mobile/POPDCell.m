//
//  POPDCell.m
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import "POPDCell.h"

@implementation POPDCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    
//    self.colorSet = SwipeCellColorSetMake([UIColor greenColor],
//                                          [UIColor whiteColor],
//                                          [UIColor whiteColor],
//                                          [UIColor whiteColor]);
//
   // self.backgroundColor = [UIColor darkGrayColor];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


@end
