//
//  SignUpContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/14/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpContainerViewController.h"
#import "SignUpViewController.h"
#import "SignUpProfileViewController.h"
#import "SignUpNavController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject_Constants.h"
#import "MBProgressHUD.h"

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
    
    self.emailLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.phoneLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.passwordLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.confirmLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];

    self.email.delegate = self;
    self.phone.delegate = self;
    self.password.delegate = self;
    self.confirm.delegate = self;
    
    // Do any additional setup after loading the view.
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.phone setBorderStyle:UITextBorderStyleNone];
    [self.password setBorderStyle:UITextBorderStyleNone];
    [self.confirm setBorderStyle:UITextBorderStyleNone];
   
    self.tableView.backgroundColor = [UIColor clearColor];
    for (CALayer *subLayer in self.tableView.layer.sublayers)
    {
        subLayer.cornerRadius = 10.0f;
        subLayer.masksToBounds = YES;
    }
}

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
        [self.phone becomeFirstResponder];
        return YES;
    }
}


-(BOOL)isValidPhone:(NSString *)phone
{
    if (phone.length != 14)
    {
        return NO;
    }
    else
    {
        [self.phone resignFirstResponder];
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
    [self.confirm becomeFirstResponder];
    return YES;
    }
}

-(BOOL)isPasswordConfirmed:(NSString *)password andConfirm: (NSString *)confirm
{
    if (![password isEqualToString:confirm])
    {
        return NO;
    }
    else
    {
        [self.confirm resignFirstResponder];
        return YES;
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)gatherFormInfo
{
    SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;
    NSLog(@"gathering info");
    self.valid_email = [self isValidEmail:self.email.text];
    self.valid_phone = [self isValidPhone:self.phone.text];
    self.valid_password = [self isValidPassword:self.password.text];
    self.passwords_match = [self isPasswordConfirmed:self.password.text andConfirm:self.confirm.text];
   
    NSString *temp_phone = self.phone.text ;
    
    self.temp_phone = self.valid_phone ? [temp_phone stringByReplacingCharactersInRange:
                                          NSMakeRange(5, 1) withString:@" "] : @"";
    NSLog(@"Actual phone: %@ \ntemp_phone: %@",self.phone.text,self.temp_phone);

    [signUpViewController.text_fields setObject:self.email.text forKey:@"email"];
    [signUpViewController.text_fields setObject:self.temp_phone forKey:@"phone_number"];
    [signUpViewController.text_fields setObject:self.password.text forKey:@"password"];
    [signUpViewController.text_fields setObject: self.valid_email ? @YES :@NO
        forKey:@"valid_email"];
    [signUpViewController.text_fields setObject:self.valid_phone ? @YES : @NO
        forKey:@"valid_phone"];
    [signUpViewController.text_fields setObject:self.valid_password ? @YES : @NO forKey:@"valid_password"];
    [signUpViewController.text_fields setObject:self.passwords_match ? @YES : @NO forKey:@"passwords_match"];
    
}

-(BOOL)checkForContent:(UITextField *)theTextField
{
    SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;
    
    if(self.valid_email) self.emailLabel.textColor = [UIColor blackColor];
    if(self.valid_phone) self.phoneLabel.textColor = [UIColor blackColor];
    if(self.valid_password) self.passwordLabel.textColor = [UIColor blackColor];
    if(self.passwords_match) self.confirmLabel.textColor = [UIColor blackColor];
    
    
    if([self.email.text  isEqual: @""]) self.emailLabel.textColor = [UIColor blackColor];
    if([self.phone.text  isEqual: @""]) self.phoneLabel.textColor = [UIColor blackColor];
    if([self.password.text  isEqual: @""]) self.passwordLabel.textColor = [UIColor blackColor];
    if([self.confirm.text isEqual:@""]) self.confirmLabel.textColor = [UIColor blackColor];
    
    

    //if all fields are not empty show next button
    if (![self.email.text  isEqual: @""] && ![self.phone.text  isEqual: @""]
        && ![self.password.text  isEqual: @""] && ![self.confirm.text isEqual:@""])
    {
        signUpViewController.nextButton.enabled = YES;
        return YES;
    }
    else
    {
        signUpViewController.nextButton.enabled = NO;
        
    }
    return NO;

}

// toggle next button ! finally works
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
    SignUpViewController *suvc = (SignUpViewController *) self.parentViewController;
    
    if(theTextField == self.email)
    {
        [self.email resignFirstResponder];
        [self.phone becomeFirstResponder];
    }
    if(theTextField == self.phone)
    {
        [self.phone resignFirstResponder];
        [self.password becomeFirstResponder];
    }
    
    if (theTextField == self.password)
    {
        [self.password resignFirstResponder];
        [self.confirm becomeFirstResponder];
    }

    if(theTextField == self.confirm && self.is_filled)
    {
        [self gatherFormInfo];
        [suvc performSelector:@selector(next)];
        
    
    }
    return YES;
}

// Restrict phone textField to format 123-456-7890
- (BOOL)textField:(UITextField *) textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    if (textField==self.phone){
        // All digits entered
        if (range.location == 14) {
            return NO;
        }
        
        // Reject appending non-digit characters
        if (range.length == 0 &&
            ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            return NO;
        }
        
        // Auto-add hyphen and parentheses
        if (range.length == 0 && range.location == 3 &&![[textField.text substringToIndex:1] isEqualToString:@"("]) {
            textField.text = [NSString stringWithFormat:@"(%@)-%@", textField.text,string];
            return NO;
        }
        if (range.length == 0 && range.location == 4 &&[[textField.text substringToIndex:1] isEqualToString:@"("]) {
            textField.text = [NSString stringWithFormat:@"%@)-%@", textField.text,string];
            return NO;
        }
        
        // Auto-add 2nd hyphen
        if (range.length == 0 && range.location == 9) {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        
        // Delete hyphen and parentheses when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 10 || range.location == 1)){
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
        if (range.length == 1 && range.location == 6){
            range.location=range.location-2;
            range.length = 3;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
