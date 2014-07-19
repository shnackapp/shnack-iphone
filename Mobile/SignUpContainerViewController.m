//
//  SignUpContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/14/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpContainerViewController.h"

@interface SignUpContainerViewController ()

@end

@implementation SignUpContainerViewController

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
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
if (theTextField == self.email)
{
    [self.password becomeFirstResponder];
    
    //store email to db for future logins!//////////////////////
    NSString *email = self.email.text;
    NSLog(@"%@",email);
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    
    
    if(![emailTest evaluateWithObject:email])
    {
        
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Invalid Email\n please retype", @"Invalid Email \n please retype") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
        
        self.email.text = @"";
        
        NSLog(@"------->Email is invalid");
        
    }
    else
    {
        NSLog(@"------->Email is Valid");
    }
    
}
if(theTextField == self.password)
{
    [self.password resignFirstResponder];
    
    
}


    return YES;
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
