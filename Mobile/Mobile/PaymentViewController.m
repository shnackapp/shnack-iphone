//
//  PaymentViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/6/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "PaymentViewController.h"
#import "MBProgressHUD.h"
#import "RESideMenu.h"
#import "NSObject_Constants.h"
#import "LocationsViewController.h"



@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
     */
    
    [self.stripeView setKey:@"pk_test_AUn823FKTadliNg29onudWm0"];
    self.stripeView.delegate = self;
    self.saveButton = self.navigationItem.rightBarButtonItem;
    self.saveButton.enabled = NO;
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
       self.sideMenuViewController.panGestureEnabled = YES;
    }




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    //Spinny loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Call 'createToken' when the save button is tapped
    [self.stripeView createToken:^(STPToken *token, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error) {
            // Handle error
             [self handleError:error];
        } else {
            // Send off token to your server
            [self handleToken:token];
            
            
        }
    }];}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        // Any action can be performed here
    }
}

-(void)loadReceipt:(NSString *)info
{
    UIView *receiptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 200)];
    receiptView.backgroundColor = [UIColor lightGrayColor];
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thank You", @"Thank You")
                                                      message:@"Thank you for your order. A receipt has been emailed to you!"
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
    
    
    
    UINavigationController * navigationController = self.navigationController;
    [navigationController popToRootViewControllerAnimated:NO];
}

- (void)stripeView:(STPView *)view withCard:(PKCard *)card isValid:(BOOL)valid
{
    self.saveButton.enabled = valid;
   
    
}

- (void)handleError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)handleToken:(STPToken *)token
{
    NSLog(@"Received token %@", token.tokenId);
    NSString *url = [NSString stringWithFormat:@"%@/process_stripe_info",BASE_URL];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];

    
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@&amount=%i", token.tokenId,globalCurrentOrderAmount];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"this is the url %@",url);
    NSLog(@"this is the body %@",body);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                               if (error) {
                                   // Handle error
                               }
                               [self loadReceipt:@"Hello"];
                           }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
