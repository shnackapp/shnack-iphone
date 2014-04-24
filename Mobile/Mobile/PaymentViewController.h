//
//  PaymentViewController.h
//  Mobile
//
//  Created by Spencer Neste on 4/6/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"

@interface PaymentViewController : UIViewController <STPViewDelegate>
@property STPView* stripeView;
@property UIBarButtonItem *saveButton;

@end
