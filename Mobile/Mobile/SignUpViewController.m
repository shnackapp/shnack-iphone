//
//  SignUpViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpViewController.h"

#import "SignUpContainerViewController.h"
#import "InitialViewController.h"
#import "MBProgressHUD.h"
#import "DismissSegue.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject_Constants.h"


@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.text_fields = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginView.delegate = self;
    
    self.container.layer.cornerRadius = 5.0f;

    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;

    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Sign Up", @"");
    [label sizeToFit];
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.cancelButton.titleLabel.textColor  = [UIColor whiteColor];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.nextButton.enabled = NO;
    
    SignUpContainerViewController *signUpContainerViewController
    = (SignUpContainerViewController *)  self.childViewControllers[0];
    NSLog(@"container class %@",signUpContainerViewController.class);
    
    self.error_messages.hidden = YES;

    
}

-(void) dismiss
{
    [self performSegueWithIdentifier:@"dismiss" sender:self];
    
}
//makes errors spaced out
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 24; // For really wide spacing; pick your own value
}

-(IBAction)next
{
    
    
    SignUpContainerViewController *signUpContainer = (SignUpContainerViewController *) self.childViewControllers[0];
    SignUpNavController * nav = (SignUpNavController *) self.navigationController;
    
    
    [signUpContainer gatherFormInfo];
    NSLog(@" this is valid password: %@", [self.text_fields valueForKeyPath:@"valid_password"]);
    NSLog(@" this is valid phone: %@", [self.text_fields valueForKeyPath:@"valid_phone"]);
    NSLog(@" this is valid emil: %@", [self.text_fields valueForKeyPath:@"valid_email"]);
    NSLog(@" this is valid confirm: %@", [self.text_fields valueForKeyPath:@"passwords_match"]);

    
    if([[self.text_fields valueForKeyPath:@"valid_password"] integerValue] == 1)//first check if password is syntactically correct
    {
        if([[self.text_fields valueForKeyPath:@"valid_email"] integerValue] ==1 && [[self.text_fields valueForKeyPath:@"valid_phone"] integerValue] == 1 && [[self.text_fields valueForKeyPath:@"passwords_match"] integerValue] ==1 )//then if correct and phone and email are syntactically correct, then check for uniqueness
        {
            self.error_messages.hidden = YES;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Validating";

            signUpContainer.emailLabel.textColor = [UIColor blackColor];
            signUpContainer.phoneLabel.textColor = [UIColor blackColor];

            NSString *url = [NSString stringWithFormat:@"%@/unique_email_phone",BASE_URL];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
            NSString *body     = [NSString stringWithFormat:@"email=%@&phone=%@", [self.text_fields valueForKeyPath:@"email"],[self.text_fields valueForKeyPath:@"phone_number"]];
            request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];
            NSLog(@"this is the request %@",request);
            NSLog(@"this is the body %@",body);
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       if (error) {
                                           // Handle error
                                       }
                                   }];
            
        }
        else//invalid phone or email or passwords dont match
        {
            NSString *email_error = @"\u2022 Invalid email address.";
            NSString *phone_error = @"\u2022 Invalid phone number.";
            NSString *password_mismatch =@"\u2022 Passwords do not match.";

            //show errors for syntactically incorrect fields
            NSString *error_string = @"";
            [self.view endEditing:YES];//dismiss keyboard
            if([[self.text_fields valueForKeyPath:@"valid_email"] integerValue] == 0)
            {
                signUpContainer.emailLabel.textColor = [UIColor redColor];
                if([error_string length] == 0) error_string =  email_error;
                else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:email_error];
            }
            if([[self.text_fields valueForKeyPath:@"valid_phone"] integerValue] == 0)
            {
                if([error_string length] == 0) error_string =  phone_error;
                else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:phone_error];
                signUpContainer.phoneLabel.textColor = [UIColor redColor];
            }
            if([[self.text_fields valueForKeyPath:@"passwords_match"] integerValue] == 0)
            {
                NSLog(@"im in here");
                signUpContainer.confirmLabel.textColor = [UIColor redColor];
                if([error_string length] == 0) error_string =  password_mismatch;
                else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:password_mismatch];
            }
            self.error_messages.hidden = NO;
            self.error_messages.text = error_string;
            self.error_messages.textColor = [UIColor redColor];
            self.error_messages.layer.cornerRadius = 5.0f;
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"The password must be at least 7 characters.", @"There was an error. Please try again.") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    

}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    [MBProgressHUD hideHUDForView:self.view animated:YES];

     SignUpContainerViewController *signUpContainer = (SignUpContainerViewController *) self.childViewControllers[0];
    NSString *email_exists_error = @"\u2022 This email address is already in use.";
    NSString *phone_exists_error = @"\u2022 This phone number is already in use.";
    
    NSError *error = nil;
    NSMutableDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"Received JSON is %@", receivedJSON);
    
    bool email_exists = false;
    bool phone_exists  = false;
    NSLog(@"email_exists %@",[receivedJSON valueForKey:@"email_exists"]);
    NSLog(@"phone_exists %@",[receivedJSON valueForKey:@"phone_exists"]);
    if( [[receivedJSON valueForKey:@"email_exists"] isEqualToString:@"true"])
    {
        NSLog(@"email already in use");
        email_exists = true;
    }
    else email_exists = false;
    if( [[receivedJSON valueForKey:@"phone_exists"] isEqualToString:@"true"])
    {
        NSLog(@"phone already in use");
        phone_exists = true;
    }
    else phone_exists = false;
    
    
    if([[self.text_fields valueForKeyPath:@"valid_email"] integerValue] == 1 && [[self.text_fields valueForKeyPath:@"valid_phone"] integerValue] == 1 && [[self.text_fields valueForKeyPath:@"valid_password"] integerValue] == 1 && [[self.text_fields valueForKeyPath:@"passwords_match"] integerValue] == 1 &&email_exists == false  && phone_exists == false)
    {
        NSLog(@"storing info in dictionary");
        self.error_messages.hidden = YES;
        SignUpNavController *signUpNav = [(SignUpNavController *) self navigationController];
        [signUpNav.user_info setObject:signUpContainer.email.text forKey:@"email"];
        [signUpNav.user_info setObject:[self.text_fields valueForKeyPath:@"phone_number"] forKey:@"phone_number"];
        [signUpNav.user_info setObject:signUpContainer.password.text forKey:@"password"];
        [self performSegueWithIdentifier:@"next" sender:self];
        
    }
    else
    {
        //show  errors  from in use fields
        NSString *error_string = @"";
        [self.view endEditing:YES];//dismiss keyboard
        if(email_exists == true)
        {
            if([error_string length] == 0) error_string =  email_exists_error;
            else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:email_exists_error];
            signUpContainer.emailLabel.textColor = [UIColor redColor];
            
        }
        if(phone_exists == true)
        {
            if([error_string length] == 0) error_string =  phone_exists_error;
            else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:phone_exists_error];
            signUpContainer.phoneLabel.textColor = [UIColor redColor];
            
        }
        
        
        self.error_messages.hidden = NO;
        self.error_messages.text = error_string;
        self.error_messages.textColor = [UIColor redColor];
        self.error_messages.layer.cornerRadius = 5.0f;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    
//    if([segue.identifier isEqualToString:@"next"])
//    {
//        NSLog(@"welllllll");
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
