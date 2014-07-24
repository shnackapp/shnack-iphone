//
//  ProfileContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ProfileContainerViewController.h"
#import "SignUpProfileViewController.h"
#import "SignUpViewController.h"
#import "SignUpNavController.h"

@interface ProfileContainerViewController ()

@end

@implementation ProfileContainerViewController

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
    
    
    self.first.delegate = self;
    self.last.delegate = self;

    self.firstLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    self.lastLabel.font = [UIFont fontWithName:@"Poiret One" size:17];
    
    [self.first setBorderStyle:UITextBorderStyleNone];
    [self.last setBorderStyle:UITextBorderStyleNone];
    
    SignUpProfileViewController * profile = [(SignUpProfileViewController *) self parentViewController];
    
    [profile.nextButton addTarget:self action:@selector(gatherInfo) forControlEvents:UIControlEventTouchUpInside];



    // Do any additional setup after loading the view.
}

- (BOOL) isAlphaNumeric
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([self.first.text rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}


-(BOOL)isValidFirst:(NSString *)first
{
    //NSCharacterSet *unwantedCharacters =[[NSCharacterSet alphanumericCharacterSet] invertedSet];
     if ([first isEqualToString:@""] )
    {
        
        return NO;
    }
    else
    {
        return YES;
    }
    
}

-(BOOL)isValidLast:(NSString *)last
{
    if ([last isEqualToString:@""] )
    {
        
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
    if (theTextField == self.first)
    {
        NSString *first = self.first.text;
        self.valid_first = [self isValidFirst:first];
        if (!self.valid_first)
        {
            self.firstLabel.textColor = [UIColor redColor];
            self.first.text = @"";
        }
        else
        {
            NSLog(@"first: %@ valid",first);
            self.firstLabel.textColor = [UIColor blackColor];
        }
    }
     if(theTextField == self.last)
    {
        NSString *last = self.last.text;
        self.valid_last = [self isValidLast:last];
        if (!self.valid_last)
        {
            self.lastLabel.textColor = [UIColor redColor];
            self.last.text = @"";
        }
        else
        {
            NSLog(@"Last: %@ valid",last);
            self.lastLabel.textColor = [UIColor blackColor];
        }
        
    }
   
    
    if (self.valid_first && self.valid_last)
    {
        SignUpProfileViewController  *signUpProfileViewController = [(SignUpProfileViewController *) self parentViewController];
        NSLog(@"parent class%@", signUpProfileViewController.class);
        signUpProfileViewController.nextButton.enabled = YES;
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
        [self.parentViewController performSegueWithIdentifier:@"next" sender:self.parentViewController];

    }
    
    return YES;
}

-(void)gatherInfo
{
    SignUpNavController *signUpNav = [(SignUpNavController *) self navigationController];
    [signUpNav.user_info setObject:self.first.text forKey:@"first"];
    [signUpNav.user_info setObject:self.last.text forKey:@"last"];
    
    NSLog(@"here is my info %@,%@",signUpNav.user_info.allValues[3],signUpNav.user_info.allValues[4]);
    
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
