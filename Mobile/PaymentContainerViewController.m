//
//  PaymentContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "PaymentContainerViewController.h"
#import "SignUpPaymentInfoViewController.h"
#import "SignUpViewController.h"
#import "SignUpNavController.h"

@interface PaymentContainerViewController ()

@end

@implementation PaymentContainerViewController

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
    
    self.card_no.delegate = self;
    self.expire_date.delegate = self;
    self.cvv.delegate = self;
    
    [self.card_no setBorderStyle:UITextBorderStyleNone];
    [self.expire_date setBorderStyle:UITextBorderStyleNone];
    [self.cvv setBorderStyle:UITextBorderStyleNone];
    
     SignUpPaymentInfoViewController  *signUpPaymentInfoViewController = [(SignUpPaymentInfoViewController *) self parentViewController];
    [signUpPaymentInfoViewController.doneButton addTarget:self action:@selector(gatherInfo) forControlEvents:UIControlEventTouchUpInside];
    


    // Do any additional setup after loading the view.
}


-(BOOL) isValidCard:(NSString *) card
{
    if ([card isEqualToString:@""] )
    {
        //check card validity!!!!
        
        
        
        return NO;
    }
    else
    {
        
        return YES;
    }
    
}
-(BOOL) isValidDate:(NSString *) date
{
    if ([date isEqualToString:@""] )
    {
        //check date validity!!!
        return NO;
    }
    else
    {
        return YES;
    }
    
}
-(BOOL) isValidCvv:(NSString *) code
{
    if ([code isEqualToString:@""] )
    {
        
        //check cvv validity!!!!
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(BOOL)textFieldHelper:(UITextField *)theTextField
{
    if (theTextField == self.card_no)
    {
        NSString *card = self.card_no.text;
        self.valid_card = [self isValidCard:card];
        if (!self.valid_card)
        {
            self.card_no.backgroundColor = [UIColor redColor];
            self.card_no.text = @"";
        }
        else
        {
            NSLog(@"card_no: %@ valid",card);
            self.card_no.backgroundColor = [UIColor whiteColor];
           
        }
    }
    if(theTextField == self.expire_date)
    {
        NSString *date = self.expire_date.text;
        self.valid_date = [self isValidDate:date];
        if (!self.valid_date)
        {
            self.expire_date.backgroundColor = [UIColor redColor];
            self.expire_date.text = @"";
        }
        else
        {
            NSLog(@"Expire Date: %@ valid",date);
            self.expire_date.backgroundColor = [UIColor whiteColor];
        }
        
    }
    if(theTextField == self.cvv)
    {
        NSString *cvv = self.cvv.text;
        self.valid_date = [self isValidDate:cvv];
        if (!self.valid_cvv)
        {
            self.cvv.backgroundColor = [UIColor redColor];
            self.cvv.text = @"";
        }
        else
        {
            NSLog(@"Cvv: %@ valid",cvv);
            self.cvv.backgroundColor = [UIColor whiteColor];
        }
        
    }
    
    if (self.valid_cvv && self.valid_date && self.valid_card)
    {
        SignUpPaymentInfoViewController  *signUpPaymentInfoViewController = [(SignUpPaymentInfoViewController *) self parentViewController];
        NSLog(@"parent class%@", signUpPaymentInfoViewController.class);
        signUpPaymentInfoViewController.doneButton.enabled = YES;
        return YES;
        
    }
    else return NO;
}



- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    NSLog(@"text field");
    [self textFieldHelper:theTextField];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    self.is_valid = [self textFieldHelper:theTextField];
    if(self.is_valid)
    {
        [self gatherInfo];
    }
    
    return YES;
}

-(void) gatherInfo
{
    SignUpNavController *signUpNav = [(SignUpNavController *) self navigationController];
    

    
    [signUpNav.user_info setObject:self.card_no.text forKey:@"card"];
    [signUpNav.user_info setObject:self.expire_date.text forKey:@"expire_date"];
    [signUpNav.user_info setObject:self.cvv.text forKey:@"cvv"];

    NSLog(@"here is my info %@",signUpNav.user_info.allValues[5]);
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
