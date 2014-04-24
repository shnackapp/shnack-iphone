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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://127.0.0.1:3000/api/process_stripe_info"]];
    request.HTTPMethod = @"POST";
    
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                               if (error) {
                                   // Handle error
                               }
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
