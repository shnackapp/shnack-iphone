//
//  DEMORightMenuViewController.h
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 2/11/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface RightMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property bool account_settings;
@property bool payment_info;
@property bool past_orders;
@property bool logout;


@end
