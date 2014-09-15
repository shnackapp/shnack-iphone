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

#import "KeychainItemWrapper.h"




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
    
    LoginContainerViewController  *loginView = (LoginContainerViewController *) self.parentViewController;
    
    
    self.valid_user_info = [[NSMutableDictionary alloc] initWithCapacity:2];
    // Do any additional setup after loading the view.
    
    self.emailLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.passwordLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    
    // Do any additional setup after loading the view.
    self.email.delegate = self;
    self.password.delegate = self;
    
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
        return NO;
    }
    else
    {
        [self.email resignFirstResponder];
        [self.password becomeFirstResponder];
        return YES;
    }
}

-(BOOL)isValidPassword:(NSString *)password
{
    if (password.length < 7)
    {
        return NO;
    }
    else
    {
        [self.password resignFirstResponder];
        return YES;
    }
}
-(BOOL)checkForContent:(UITextField *)theTextField
{
    LoginContainerViewController  *loginView = (LoginContainerViewController *) self.parentViewController;
    
    if(self.valid_email) self.emailLabel.textColor = [UIColor blackColor];
    if(self.valid_password) self.passwordLabel.textColor = [UIColor blackColor];
    
    //if all fields are not empty show next button
    if (![self.email.text  isEqual: @""] && ![self.password.text  isEqual: @""])
    {
        loginView.doneButton.enabled = YES;
        return YES;
    }
    else
    {
        loginView.doneButton.enabled = NO;
        
    }
    return NO;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.is_filled = [self checkForContent:textField];
    [textField addTarget:self action:@selector(checkForContent:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    
    self.is_filled = [self checkForContent:theTextField];
}
//enable check on done button on keybaord
-(BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    self.is_filled = [self checkForContent:theTextField];
    LoginContainerViewController *lvc = (LoginContainerViewController *) self.parentViewController;
    
    if(theTextField == self.email)
    {
        [self.email resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    
    if(theTextField == self.password && self.is_filled)
    {
        [self gatherFormInfo];
        [lvc performSelector:@selector(submit)];
        
        
    }
    return YES;
}




-(void)gatherFormInfo
{
    
    
    self.valid_email = [self isValidEmail:self.email.text];
    self.valid_password = [self isValidPassword:self.password.text];
    
    [self.valid_user_info setObject: self.valid_email ? @YES :@NO forKey:@"valid_email"];
    [self.valid_user_info setObject: self.valid_password ? @YES :@NO forKey:@"valid_password"];

    
    if(self.valid_email && self.valid_password)
    {
        LoginContainerViewController  *loginViewController = (LoginContainerViewController *) self.parentViewController;
        NSLog(@" parent class%@", loginViewController.class);
        loginViewController.doneButton.enabled = YES;
        
        NSMutableArray *login_credentials = [[NSMutableArray alloc] init];
        
        //currentUser = [[NSMutableArray alloc] init];
        [login_credentials addObject:self.email.text];
        [login_credentials addObject:self.password.text];
        NSLog(@" %@, %@", [self.valid_user_info valueForKey:@"valid_email"],[self.valid_user_info valueForKey:@"valid_password"]);
        
        globalCurrentUser = login_credentials;
        
        
        
    }
    
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
