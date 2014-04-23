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
            //self.Login.enabled=NO;
    }
    if (theTextField == self.password)
    {
        [theTextField resignFirstResponder];
            //self.Login.enabled=NO;
    }
        //store password to db for future logins////////////////////////////
    self.Login.enabled=YES;

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

    
    self.Login.enabled=NO;
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
