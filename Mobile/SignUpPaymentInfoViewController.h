//
//  SignUpPaymentInfoViewController.h
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPView.h"

@interface SignUpPaymentInfoViewController : UIViewController
@property IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet STPView *stripeView;
extern int *globalCurrentOrderAmount;

-(IBAction)done;
-(void)createUserWithInfo:(NSString *)name andEmail:(NSString *)email andPhone:(NSString *)phone andPassword:(NSString *)password andStripeToken:(NSString *) token;

@end
