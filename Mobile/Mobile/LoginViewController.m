//
//  LoginViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LoginViewController.h"
<<<<<<< HEAD
#import "LoginContainerViewController.h"

#import "NSObject_Constants.h"
#import "MBProgressHUD.h"
=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a

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
<<<<<<< HEAD
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
        //add action to done button!
        //[loginViewController.doneButton addTarget:self action: @selector(submit) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableArray *login_credentials = [[NSMutableArray alloc] init];
        //currentUser = [[NSMutableArray alloc] init];
        [login_credentials addObject:self.email.text];
        [login_credentials addObject:self.password.text];
        globalCurrentUser = login_credentials;
        
        
        
    }
=======
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.email)
    {
        [self.password becomeFirstResponder];
        self.Login.hidden=YES;
        
        NSString *email = self.email.text;
        BOOL stricterFilter = YES;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        if(![emailTest evaluateWithObject:email])
        {
            
            self.email.text = @"";
            self.validEmail = false;
        }
        else
        {
            self.validEmail = true;
        }
    }
    else if (theTextField == self.password)
    {
        [self.phone becomeFirstResponder];
        self.Login.hidden=YES;
        self.validPassword = true;
    }
    else if (theTextField == self.phone)
    {
        [theTextField resignFirstResponder];
        self.validPhone = true;

    }
        //store password to db for future logins////////////////////////////
    if(self.validEmail && self.validPassword && self.validPhone)
    {//unhide
        self.Login.hidden = NO;
    }

>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< HEAD
    
    //[self.email becomeFirstResponder];
    
    // Do any additional setup after loading the view.
    self.email.delegate = self;
    self.password.delegate = self;
    
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.password setBorderStyle:UITextBorderStyleNone];
    
    self.loginEmailLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    self.loginPasswordLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    
=======
    // Do any additional setup after loading the view.
    self.phone.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.validPassword = false;
    self.validPhone = false;
    self.validEmail = false;

    
    self.Login.hidden=YES;
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

<<<<<<< HEAD


=======
>>>>>>> ae4b0d1c72f6836f8319d377ff50cf08c6ccc50a
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
