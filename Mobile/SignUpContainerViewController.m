//
//  SignUpContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/14/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpContainerViewController.h"
#import "SignUpViewController.h"
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
    
    NSLog(@"IN container");
    [super viewDidLoad];
    
    //[NSThread sleepForTimeInterval:.5];
    //[self.email becomeFirstResponder];
    self.nameLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    self.emailLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    self.phoneLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    self.passwordLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    
    
    self.name.delegate = self;
    self.email.delegate = self;
    self.phone.delegate = self;
    self.password.delegate = self;

    // Do any additional setup after loading the view.
    [self.name setBorderStyle:UITextBorderStyleNone];
    [self.email setBorderStyle:UITextBorderStyleNone];
    [self.password setBorderStyle:UITextBorderStyleNone];
    [self.phone setBorderStyle:UITextBorderStyleNone];

}

-(IBAction)submit:(UIButton *)sender
    {
        

    }

-(BOOL)isValidName:(NSString *)name
{
    if ([name isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        [self.email becomeFirstResponder];
        return YES;
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
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error") message:NSLocalizedString(@"Invalid Email\n please retype", @"Invalid Email \n please retype") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        self.email.text = @"";
        NSLog(@"------->Email is invalid");
        
        return NO;
    }
    else
    {
        [self.email resignFirstResponder];
        [self.phone becomeFirstResponder];
        NSLog(@"------->Email is Valid");
        return YES;
    }
}


-(BOOL)isValidPhone:(NSString *)phone
{
    if (phone.length != 14) return NO;
    else
    {
        [self.email resignFirstResponder];
        [self.password becomeFirstResponder];
        return YES;
    }
}

-(BOOL)isValidPassword:(NSString *)password
{
    if (password.length < 7) return NO;
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



- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.name)
    {
        NSString *name = self.name.text;
        NSLog(@"Name: %@", name);
        self.valid_name = [self isValidName:name];
        if(!self.valid_name)
        {
            self.emailLabel.textColor = [UIColor redColor];
        }
        else self.emailLabel.textColor = [UIColor blackColor];

    }
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
    if(theTextField == self.phone)
    {
    NSString *phone = self.phone.text;
    NSLog(@"Phone: %@",phone);
    self.valid_phone = [self isValidPhone:phone];
        if (!self.valid_phone)
        {
            self.phoneLabel.textColor = [UIColor redColor];
            self.phone.text = @"";
        }
        else self.phoneLabel.textColor = [UIColor blackColor];

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
        else self.passwordLabel.textColor = [UIColor blackColor];

    }
    
    if (self.valid_email && self.valid_phone && self.valid_password)
    {
        SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;
        NSLog(@" parent class%@", signUpViewController.class);
        signUpViewController.doneButton.enabled = YES;
        
        NSMutableArray *user_info =  [[NSMutableArray alloc] init];
        [user_info addObject:self.name.text];
        [user_info addObject:self.email.text];
        [user_info addObject:self.phone.text];
        [user_info addObject:self.password.text];
        globalUserInfo = user_info;
        
        NSLog(@"here is my info %@,%@,%@,%@",globalUserInfo[0],globalUserInfo[1],globalUserInfo[2],globalUserInfo[3]);

        [self createUserWithInfo:self.name.text andEmail:self.email.text andPhone:self.phone.text andPassword:self.password.text];
    }
    return YES;
}

-(void)createUserWithInfo:(NSString *)name andEmail:(NSString *)email andPhone:(NSString *)phone andPassword:(NSString *)password;
{
    NSString *url = [NSString stringWithFormat:@"%@/create",BASE_URL];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:@"Authorization"];
    //[request setValue:@"application/html" forHTTPHeaderField:@"Content-Type"];

    NSString *body    = [NSString stringWithFormat:@"name=%@&email=%@&phone=%@&password=%@", globalUserInfo[0],globalUserInfo[1],globalUserInfo[2],globalUserInfo[3]];

    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"this is the url %@",url);
    NSLog(@"this is the body %@",body);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                               
                               if (error) {
                                   // Handle error
                               }
                           }];
   
}

// Restrict phone textField to format 123-456-7890
- (BOOL)textField:(UITextField *)textField
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
