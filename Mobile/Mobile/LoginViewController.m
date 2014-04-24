//
//  LoginViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/22/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LoginViewController.h"

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
    // Do any additional setup after loading the view.
    self.phone.delegate = self;
    self.email.delegate = self;
    self.password.delegate = self;
    
    self.validPassword = false;
    self.validPhone = false;
    self.validEmail = false;

    
    self.Login.hidden=YES;
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
