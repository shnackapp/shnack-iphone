//
//  LoginContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 5/28/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LoginContainerViewController.h"
#import "LoginViewController.h"
#import "NSObject_Constants.h"
#import "MBProgressHUD.h"
#import "AccountTableViewController.h"
#import "AppDelegate.h"


@interface LoginContainerViewController ()

@end

@implementation LoginContainerViewController

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
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.doneButton.enabled = NO;
    self.cancelButton.titleLabel.textColor  = [UIColor whiteColor];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  
  
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
    label.text = NSLocalizedString(@"Log In", @"");
    [label sizeToFit];
    
    self.forgotPassword.titleLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:16];
}

- (void)
loginViewFetchedUserInfo:	(FBLoginView *)loginView
user:	(id<FBGraphUser>)user
{
  NSLog(@"IM IN HERE! %@", user);
  uses_keychain = NO;
  uses_facebook = YES;
  
  [fb_user_info setValue:user forKey:@"user"];
  
  
  
  NSLog(@"uses_keychain_login: %d", uses_keychain ? YES:NO);
  NSLog(@"uses_fb_login: %d", uses_facebook ? YES:NO);
  
  

  
}

-(void)forgot_password
{
    NSLog(@"IFORGOT");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.shnackapp.com/users/sign_in"]];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)submit
{
    LoginViewController *lvc = (LoginViewController *) self.childViewControllers[0];
    [lvc gatherFormInfo];
    NSLog(@"this is lvc email: %@ password: %@",[lvc.valid_user_info valueForKeyPath:@"valid_email"], [lvc.valid_user_info valueForKeyPath:@"valid_password"]);
    if([[lvc.valid_user_info valueForKeyPath:@"valid_email"] integerValue] ==1 && [[lvc.valid_user_info valueForKeyPath:@"valid_password"] integerValue] ==1)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Logging in";
        NSString *url = [NSString stringWithFormat:@"%@/login",BASE_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
        
        NSString *body    = [NSString stringWithFormat:@"email=%@&password=%@",
        globalCurrentUser[0],globalCurrentUser[1]];
        
        request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];

        NSLog(@"this is the url %@",url);
        NSLog(@"this is the body %@",body);
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   
                               }];
    }
    else{
      
      NSString *email_error = @"\u2022 Invalid email address.";
      NSString *password_error = @"\u2022 Invalid password.";
      
      //show errors for syntactically incorrect fields
      NSString *error_string = @"";
        if ([[lvc.valid_user_info valueForKeyPath:@"valid_email"] integerValue] ==0 )
        {
          lvc.emailLabel.textColor = [UIColor redColor];
          
          if([error_string length] == 0) error_string =  email_error;
          else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:email_error];
                NSLog(@"invalid syntax");
          
          
        }
        else if ([[lvc.valid_user_info valueForKeyPath:@"valid_password"] integerValue] ==0 )
        {
          lvc.passwordLabel.textColor = [UIColor redColor];
          
          if([error_string length] == 0) error_string =  password_error;
          else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:password_error];
          NSLog(@"invalid syntax");

        }
      
      
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(error_string,error_string) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
    }
  
}



-(void) dismiss
{
    [self.view endEditing:YES];//dismiss keyboard before cancel
    [self performSegueWithIdentifier:@"dismiss" sender:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if( [identifier isEqualToString:@"to_root"])
    {
    if (self.successful_login )
    {
        return YES;
    }
    else return NO;//user does not exist so do not segue
    }
    else return YES;
    
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"rD %@",self.responseData);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSLog(@" here%@", self.responseData);
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
    
    NSError *error = nil;
    NSMutableDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"Received JSON is %@", receivedJSON);
  
  KeychainItemWrapper *password = [[KeychainItemWrapper alloc] initWithIdentifier:@"password" accessGroup:nil];
  [password setObject:@"password" forKey: (__bridge id)kSecAttrService];
  [password setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *email = [[KeychainItemWrapper alloc] initWithIdentifier:@"email" accessGroup:nil];
  [email setObject:@"email" forKey: (__bridge id)kSecAttrService];
  [email setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *name = [[KeychainItemWrapper alloc] initWithIdentifier:@"name" accessGroup:nil];
  [name setObject:@"name" forKey: (__bridge id)kSecAttrService];
  [name setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *phone = [[KeychainItemWrapper alloc] initWithIdentifier:@"phone" accessGroup:nil];
  [phone setObject:@"phone" forKey: (__bridge id)kSecAttrService];
  [phone setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  KeychainItemWrapper *token = [[KeychainItemWrapper alloc] initWithIdentifier:@"token" accessGroup:nil];
  [token setObject:@"token" forKey: (__bridge id)kSecAttrService];
  [token setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  
   AppDelegate *app  = (AppDelegate *)[[UIApplication sharedApplication] delegate];

  
    int i =1;
  
    for(id key in receivedJSON)
    {
        id value = [receivedJSON objectForKey:key];
        NSLog(@" here is value %@",value);
      
      if([key isEqualToString:@"error"])
      {
        if([value isEqualToString:@"incorrect_password"])
        {
            self.successful_login = NO;
            LoginViewController *container = (LoginViewController *) self.childViewControllers[0];
            container.password.text=@"";
            container.passwordLabel.textColor = [UIColor redColor];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"\u2022 Invalid Password!", @"\u2022 Invalid Password!") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        if([value isEqualToString:@"incorrect_email"])
        {
            self.successful_login = NO;

            LoginViewController *container = (LoginViewController *) self.childViewControllers[0];
            container.email.text=@"";
            container.password.text=@"";
            container.emailLabel.textColor = [UIColor redColor];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"\u2022 Email address does not exist!", @"\u2022 Email address does not exist!") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
      }
      else
      {
        
        if(i == 1)
        {
          //[keychainItem setObject:@"Myappstring" forKey: (__bridge id)kSecAttrService];

          i=0;// only store password once
        //store cred into keychain once we know it is legitimate
          [password setObject:globalCurrentUser[1] forKey:(__bridge id)(kSecValueData)];
          [shnack_user_info setValue:globalCurrentUser[1] forKey:@"password"];
        }
        
        if([key isEqualToString:@"name"])
        {
          [shnack_user_info setValue:[receivedJSON objectForKey:key] forKey:@"name"];
          [name setObject:[receivedJSON objectForKey:key] forKey:(__bridge id)(kSecValueData)];

        }
        if([key isEqualToString:@"email"])
        {
          [shnack_user_info setValue:[receivedJSON objectForKey:key] forKey:@"email"];
          [email setObject:[receivedJSON objectForKey:key] forKey:(__bridge id)(kSecValueData)];
        }
        if([key isEqualToString:@"phone_number"])
        {
          [shnack_user_info setValue:[receivedJSON objectForKey:key] forKey:@"phone_number"];
          [phone setObject:[receivedJSON objectForKey:key] forKey:(__bridge id)(kSecValueData)];
          
        }
        if([key isEqualToString:@"auth_token"])
        {
          [shnack_user_info setValue:[receivedJSON objectForKey:key] forKey:@"auth_token"];
          [token setObject:[receivedJSON objectForKey:key] forKey:(__bridge id)(kSecValueData)];
        }
            self.successful_login = YES;
      }
        
    }
   NSLog(@"Shnack User Info: %@",shnack_user_info);
   NSLog(@"password: %@",[password objectForKey:(__bridge id)(kSecValueData)]);
   NSLog(@"auth_token: %@",[token objectForKey:(__bridge id)(kSecValueData)]);
   NSLog(@"email: %@",[email objectForKey:(__bridge id)(kSecValueData)]);
   NSLog(@"name: %@",[name objectForKey:(__bridge id)(kSecValueData)]);
   NSLog(@"phone_number: %@",[phone objectForKey:(__bridge id)(kSecValueData)]);


    if(self.successful_login)
    {
      //dismiss login controller and then present locations
        [self performSegueWithIdentifier:@"dismiss" sender:self];
        [self.presentingViewController performSegueWithIdentifier:@"to_root" sender:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"here?");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"It looks like our servers are down! Please try again later", @"It looks like our servers are down! Please try again later") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    

}

#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
