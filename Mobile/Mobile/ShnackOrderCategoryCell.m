//
//  ShnackOrderCategoryCell.m
//  Mobile
//
//  Created by Jake Staahl on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ShnackOrderCategoryCell.h"

@implementation ShnackOrderCategoryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)layoutSubviews
{
    //self.backgroundColor =[UIColor colorWithRed:0.25f green:0.60f blue:1.00f alpha:1.00f];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
