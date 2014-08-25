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

    self.email.delegate = self;
    self.phone.delegate = self;
    self.password.delegate = self;
    
    // Do any additional setup after loading the view.
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.password setBorderStyle:UITextBorderStyleNone];
    [self.phone setBorderStyle:UITextBorderStyleNone];
    
    SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;
    
    
    self.tableView.backgroundColor = [UIColor clearColor];
    for (CALayer *subLayer in self.tableView.layer.sublayers)
    {
        subLayer.cornerRadius = 5.0f;
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
    [self.phone resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
    }
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



-(BOOL)gatherAndCheckForm
{
    SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;
    NSLog(@"gathering info");
    
    NSString *email_error = @"\u2022 Email incorrect.";
    NSString *phone_error = @"\u2022 Phone number was not correct.";
    NSString *password_error = @"\u2022 Password must be at least 6 characters.";
    NSString *email_exists_error = @"\u2022 This email address is already in use.";
    NSString *phone_exists_error = @"\u2022 This phone number is already in use.";
    
    
    SignUpNavController * nav = (SignUpNavController *) self.navigationController;

    self.valid_email = [self isValidEmail:self.email.text];
    self.valid_phone = [self isValidPhone:self.phone.text];
    self.valid_password = [self isValidPassword:self.password.text];
    NSString *temp_phone1 = [[NSString alloc] init];

    if(self.valid_password)//first check if password is syntactically correct
    {
    if(self.valid_email && self.valid_phone)//then if correct and phone and email are syntactically correct, then check for uniqueness
    {

        
    NSString *url = [NSString stringWithFormat:@"%@/unique_email_phone",BASE_URL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    
    NSString *temp_phone = self.phone.text ;
    NSUInteger len = [self.phone.text length];
    NSLog(@"length %lu", (unsigned long)len);
    if([temp_phone characterAtIndex:5] == '-' )//remove the first dash for storing in db
    {
        temp_phone1 = [temp_phone stringByReplacingCharactersInRange:
                    NSMakeRange(5, 1) withString:@" "];
        NSLog(@"Actual phone: %@ \ntemp_phone: %@",self.phone.text,temp_phone1);
        
    }
    

    NSString *body     = [NSString stringWithFormat:@"email=%@&phone=%@", self.email.text,temp_phone1];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"this is the url %@",url);
    NSLog(@"this is the body %@",body);

    NSURLResponse *response = nil;
    NSError *error = nil;

    self.receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
    }
    else//invalid phone or email
    {
        //show errors for syntactically incorrect fields
        NSString *error_string = @"";
        [self.view endEditing:YES];//dismiss keyboard
        if(!self.valid_email)
        {
            self.emailLabel.textColor = [UIColor redColor];
            if([error_string length] == 0) error_string =  email_error;
            else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:email_error];
        }
        if(!self.valid_phone)
        {
            
            if([error_string length] == 0) error_string =  phone_error;
            else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:phone_error];
            self.phoneLabel.textColor = [UIColor redColor];
            
            
        }
        signUpViewController.error_messages.hidden = NO;
        signUpViewController.error_messages.text = error_string;
        signUpViewController.error_messages.textColor = [UIColor redColor];
        signUpViewController.error_messages.layer.cornerRadius = 5.0f;
    }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"The password must be at least 6 characters.", @"There was an error. Please try again.") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
 if(self.receivedData != nil)
 {
    NSError *error = nil;

    NSMutableDictionary *receivedJSON = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Received JSON is %@", receivedJSON);
    bool email_exists = false;
    bool phone_exists  = false;
    NSLog(@"email_exists %@",[receivedJSON valueForKey:@"email_exists"]);
    NSLog(@"phone_exists %@",[receivedJSON valueForKey:@"phone_exists"]);
    if( [[receivedJSON valueForKey:@"email_exists"] isEqualToString:@"true"])
    {
        NSLog(@"email already in use");
        email_exists = true;
    }
    else email_exists = false;
    if( [[receivedJSON valueForKey:@"phone_exists"] isEqualToString:@"true"])
    {
        NSLog(@"phone already in use");
        phone_exists = true;
    }
    else phone_exists = false;
    if(self.valid_email && self.valid_phone && self.valid_password && email_exists == false  && phone_exists == false)
    {
        NSLog(@"storing info in dictionary");
        SignUpNavController *signUpNav = [(SignUpNavController *) self navigationController];
        [signUpNav.user_info setObject:self.email.text forKey:@"email"];
        [signUpNav.user_info setObject:temp_phone1 forKey:@"phone_number"];
        [signUpNav.user_info setObject:self.password.text forKey:@"password"];
        return YES;
    }
    else
    {
        //show  errors  from in use fields
        NSString *error_string = @"";
        [self.view endEditing:YES];//dismiss keyboard
        if(email_exists == true)
        {
            if([error_string length] == 0) error_string =  email_exists_error;
            else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:email_exists_error];
            self.emailLabel.textColor = [UIColor redColor];
            
        }
        if(phone_exists == true)
        {
            if([error_string length] == 0) error_string =  phone_exists_error;
            else error_string = [[error_string stringByAppendingString:@"\n"] stringByAppendingString:phone_exists_error];
            self.phoneLabel.textColor = [UIColor redColor];
            
        }
        signUpViewController.error_messages.hidden = NO;
        signUpViewController.error_messages.text = error_string;
        signUpViewController.error_messages.textColor = [UIColor redColor];
        signUpViewController.error_messages.layer.cornerRadius = 5.0f;
        return NO;
    }
 }
 else{
//     NSLog(@"no connection");
//     
//     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"There was an error. Please try again.", @"There was an error. Please try again.") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//     [alert show];
//     
//    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     return NO;
 }
    
    
}

-(BOOL)checkForContent:(UITextField *)theTextField
{
    SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;

    //if all fields are not empty show next button
    if (![self.email.text  isEqual: @""] && ![self.phone.text  isEqual: @""]
        && ![self.password.text  isEqual: @""])
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
    if(self.valid_email) self.emailLabel.textColor = [UIColor blackColor];
    if(self.valid_phone) self.phoneLabel.textColor = [UIColor blackColor];
    if(self.valid_password) self.passwordLabel.textColor = [UIColor blackColor];
    
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    
    self.is_filled = [self checkForContent:theTextField];

    
}
//enable check on done button on keybaord
-(BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    self.is_filled = [self checkForContent:theTextField];
    
    if(theTextField == self.email)
    {
        [self.email resignFirstResponder];
        [self.phone becomeFirstResponder];
    }

    if(theTextField == self.password)
    {
        self.is_valid = [self gatherAndCheckForm];
    
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
