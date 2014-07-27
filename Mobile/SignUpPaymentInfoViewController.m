//
//  SignUpPaymentInfoViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpPaymentInfoViewController.h"
#import "SignUpNavController.h"
#import "MBProgressHUD.h"
#import "RESideMenu.h"
#import "NSObject_Constants.h"
#import "LocationsViewController.h"

@interface SignUpPaymentInfoViewController ()

@end

@implementation SignUpPaymentInfoViewController

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
    
    [self.stripeView setKey:PUBLISHABLE_TEST];
    self.stripeView.delegate = self;
    self.saveButton.enabled = NO;
    
    // important! set whether the user should be able to swipe from the right to reveal the side menu
    self.sideMenuViewController.panGestureEnabled = YES;
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
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thank You", @"Thank You")
                                                      message:@"Thank you for your order. A receipt has been emailed to you!"delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")otherButtonTitles:nil];[message show];
    
    
    //change this ,just tmporary for testing
//    UINavigationController * navigationController = self.navigationController;
//    [navigationController popToRootViewControllerAnimated:NO];
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
    self.saveButton.enabled = NO;
}

- (void)handleToken:(STPToken *)token
{
    
    SignUpNavController * nav = (SignUpNavController *) self.navigationController;
    NSLog(@"Received token %@", token.tokenId);
    NSString *url = [NSString stringWithFormat:@"%@/customer",BASE_URL];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    
    
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@&stripeEmail=%@", token.tokenId,[nav.user_info objectForKey:@"email"]];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"this is the url %@",url);
    NSLog(@"this is the body %@",body);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                               if (error) {
                                   // Handle error
                                   [self handleError:error];

                               }

                               }];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    _receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error)
    {
        NSLog(@"@ERROR_RESPONSE%@", error);
        
    }
    
    
    NSMutableDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Received JSON is %@", receivedJSON);
    
    
//    for(id key in receivedJSON) {
//        
//        
//        NSString *value = [receivedJSON valueForKey:@"id"];
//        NSLog(@"%@ : %@",key,value);
//    }
//
    
    if([receivedJSON objectForKey:@"card_error"])
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                          message:[error localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                otherButtonTitles:nil];
        [message show];

        
    }
    
    NSString *full_name = [[[nav.user_info objectForKey:@"first"] stringByAppendingString:@" "] stringByAppendingString:[nav.user_info objectForKey:@"last"]];
    
    [nav.user_info setObject:[receivedJSON valueForKey:@"id"] forKey:@"id"];
    
    [self createUserWithInfo:full_name andEmail:[nav.user_info objectForKey:@"email"] andPhone:[nav.user_info objectForKey:@"phone_number"] andPassword:[nav.user_info objectForKey:@"password"] andStripeCustomerID:[nav.user_info objectForKey:@"id"]];
    [self performSegueWithIdentifier:@"order" sender:self];
}



-(void)createUserWithInfo:(NSString *)name andEmail:(NSString *)email andPhone:(NSString *)phone andPassword:(NSString *)password andStripeCustomerID:(NSString *) customer_id;
{
        NSString *url = [NSString stringWithFormat:@"%@/create",BASE_URL];
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    
        NSString *body    = [NSString stringWithFormat:@"name=%@&email=%@&phone=%@&password=%@&customer_id=%@", name,email,phone,password,customer_id];
    
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
                                         }];
    NSLog(@"CREATED USER WITH PAYMENT INFO");
    
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"order"]) {
        UINavigationController *nav = [[UINavigationController alloc] initWithNibName:@"contentViewController" bundle:nil];
            }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
