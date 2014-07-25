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
<<<<<<< HEAD
@property UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet STPView *stripeView;
extern int *globalCurrentOrderAmount;
-(void)loadReceipt:(NSString*)info;
=======
@property STPView* stripeView;
@property UIBarButtonItem *saveButton;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

@end
