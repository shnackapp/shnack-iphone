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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)submit
{
        self.does_exist = self.login;
        if(self.does_exist)
        {
            [self performSegueWithIdentifier:@"logged_in" sender:self];
        }
        else
        {
            //clear fields
            LoginViewController *container = (LoginViewController *) self.childViewControllers[0];
            container.email.text = @"";
            container.password.text =@"";
    
    
        }
}

-(BOOL)login
{
    NSString *url = [NSString stringWithFormat:@"%@/login",BASE_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    
    NSString *body    = [NSString stringWithFormat:@"email=%@&password=%@", globalCurrentUser[0],globalCurrentUser[1]];
    
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"this is the url %@",url);
    NSLog(@"this is the body %@",body);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                               if (error) {
                                   
                               }
                           }];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    _receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error)
    {
        
    }
    
    
    NSMutableDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Received JSON is %@", receivedJSON);
    
    for(id key in receivedJSON) {
        id value = [receivedJSON objectForKey:key];
        NSLog(@" here is value %@",value);
        if([value isEqualToString:@"incorrect_password"])
        {
            self.successful_login = NO;
            LoginViewController *container = (LoginViewController *) self.childViewControllers[0];
            container.password.text=@"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Incorrect Password!", @"Incorrect Password") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        else if([value isEqualToString:@"incorrect_email"])
        {
            self.successful_login = NO;
            LoginViewController *container = (LoginViewController *) self.childViewControllers[0];
           container.email.text=@"";
            container.password.text=@"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Email does not exist!", @"Email does not exist!") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            
            self.successful_login = YES;
        }
        
    }
    
    if (receivedJSON == nil || !self.successful_login)
    {
        return NO;
    }
    else return YES;
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.loginTitle.font = [UIFont fontWithName:@"Poiret One" size:26];
    
    self.forgotPassword.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    
//    LoginViewController *container = (LoginViewController *) self.childViewControllers[0];
//    [container.password addTarget:self action:@selector(submit) forControlEvents:UIControlEvent
//    [self.password setAction:@selector(someAction:)];
//    



    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)home
{
    NSLog(@"clikced cancel");
    
    [self performSegueWithIdentifier:@"Unwind" sender:self];
    
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if( [identifier isEqualToString:@"logged_in"])
    {
    
    if (self.does_exist )
    {
        return YES;
    }
    else return NO;//user does not exist so do not segue
    }
    else return YES;
    
}


/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
