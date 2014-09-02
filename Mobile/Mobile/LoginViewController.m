//
//  LoginViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginContainerViewController.h"

#import "NSObject_Constants.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.valid_user_info = [[NSMutableDictionary alloc] initWithCapacity:2];
    // Do any additional setup after loading the view.
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.emailLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.passwordLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    
    // Do any additional setup after loading the view.
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.password setBorderStyle:UITextBorderStyleNone];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    for (CALayer *subLayer in self.tableView.layer.sublayers)
    {
        subLayer.cornerRadius = 5.0f;
        subLayer.masksToBounds = YES;
    }
    
    [super viewDidLoad];
    
}
//validations
-(BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if(![emailTest evaluateWithObject:email])
    {
        
        self.email.text = @"";
        NSLog(@"------->Email is invalid");
        
        return NO;
    }
    else
    {
        [self.email resignFirstResponder];
        [self.password becomeFirstResponder];
        NSLog(@"------->Email is Valid");
        return YES;
    }
}

-(BOOL)isValidPassword:(NSString *)password
{
    if (password.length < 7) return NO;
    else
    {
        [self.email resignFirstResponder];
        [self.password resignFirstResponder];
        return YES;
    }
}

//

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

    if (theTextField == self.email)
    {
        NSString *email = self.email.text;
        NSLog(@"Email: %@",email);
        self.valid_email = [self isValidEmail:email];
        if (!self.valid_email)
        {
            self.emailLabel.textColor = [UIColor redColor];
            self.email.text = @"";
        }
        else self.emailLabel.textColor = [UIColor blackColor];
    }
    if(theTextField == self.password)
    {
        NSString *password = self.password.text;
        NSLog(@"Password: %@",password);
        self.valid_password = [self isValidPassword:password];
        if (!self.valid_password)
        {
            self.passwordLabel.textColor = [UIColor redColor];
            self.password.text = @"";
        }
        else
        {
            self.passwordLabel.textColor = [UIColor blackColor];
            LoginContainerViewController  *loginViewController = (LoginContainerViewController *) self.parentViewController;
            //[loginViewController submit];
        
        }
        
    }
    if(self.valid_email && self.valid_password)
    {
        LoginContainerViewController  *loginViewController = (LoginContainerViewController *) self.parentViewController;
        NSLog(@" parent class%@", loginViewController.class);
        loginViewController.doneButton.enabled = YES;
       
        NSMutableArray *login_credentials = [[NSMutableArray alloc] init];
        
        //currentUser = [[NSMutableArray alloc] init];
        [login_credentials addObject:self.email.text];
        [login_credentials addObject:self.password.text];
        
        [self.valid_user_info setObject: self.valid_email ? @YES :@NO forKey:@"valid_email"];
        [self.valid_user_info setObject: self.valid_password ? @YES :@NO forKey:@"valid_email"];

        globalCurrentUser = login_credentials;
        
        
        
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
