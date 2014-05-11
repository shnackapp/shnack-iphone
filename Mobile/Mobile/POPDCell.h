//
//  POPDCell.h
//  popdowntable
//
//  Created by Alex Di Mango on 15/09/2013.
//  Copyright (c) 2013 Alex Di Mango. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JZSwipeCell.h"



@interface POPDCell :  UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic) BOOL isOpen;







@end
