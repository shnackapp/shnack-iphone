//
//  SignUpViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpViewController.h"

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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.email)
    {
        [theTextField resignFirstResponder];

        //store email to db for future logins!//////////////////////
        NSString *email = self.email.text;
        BOOL stricterFilter = YES;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

        if(![emailTest evaluateWithObject:email])
        {

//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Invalid Email\n please retype", @"Invalid Email \n please retype") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            
            self.email.text = @"";
            self.validEmail = false;
            self.invalidEmail.hidden = NO;

            NSLog(@"------->Email is invalid");

        }
        else
        {
            self.validEmail = true;
            //self.password.hidden = NO;
           // self.passwordLabel.hidden = NO;
            self.invalidEmail.hidden = YES;
            NSLog(@"------->Email is Valid");
        }

    }
    if(theTextField == self.password)
    {
        [theTextField resignFirstResponder];

        //self.passwordConfirm.hidden = NO;
        //self.passwordConfirmLabel.hidden = NO;

    }

    if (theTextField == self.passwordConfirm)
    {

        [theTextField resignFirstResponder];
        NSString *password = self.password.text;
        NSString *passwordConfirm = self.passwordConfirm.text;
        NSLog(@"------->Password %@", password);
        NSLog(@"------->Password %@", passwordConfirm);
        if (![password isEqualToString:passwordConfirm])
        {

//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Passwords do not match \n please retype", @"Passwords do not match \n please retype") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            self.passwordMismatch.hidden = NO;
            self.password.text = @"";
            self.passwordConfirm.text = @"";
            self.passwordMatch = false;
            NSLog(@"------->Passwords do not match");



        }
        else
        {
            self.passwordMatch = true;
            self.passwordMismatch.hidden = YES;

            NSLog(@"------->Passwords match");

        }
        //store password to db for future logins////////////////////////////
    }
    
    if(self.validEmail && self.passwordMatch)
    {
        NSLog(@"Email is valid and Passwords Match");
        self.startOrdering.hidden=NO;
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
    self.passwordConfirm.delegate = self;
    self.password.delegate = self;
    self.email.delegate = self;
    
    self.startOrdering.hidden=YES;
    self.passwordMismatch.hidden = YES;
    self.invalidEmail.hidden = YES;
    
//    self.password.hidden = YES;
//    self.passwordLabel.hidden = YES;
//
//    self.passwordConfirm.hidden = YES;
//    self.passwordConfirmLabel.hidden = YES;






    
    // Do any additional setup after loading the view.
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
