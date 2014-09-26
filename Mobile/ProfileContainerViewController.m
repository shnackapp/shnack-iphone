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
    
    self.tableView.backgroundColor = [UIColor clearColor];
    for (CALayer *subLayer in self.tableView.layer.sublayers)
    {
        subLayer.cornerRadius = 5.0f;
        subLayer.masksToBounds = YES;
    }
    
    
    self.first.delegate = self;
    self.last.delegate = self;

    self.firstLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    self.lastLabel.font = [UIFont fontWithName:@"Dosis-Medium" size:17];
    
    [self.first setBorderStyle:UITextBorderStyleNone];
    [self.last setBorderStyle:UITextBorderStyleNone];
    
    SignUpProfileViewController * profile = [(SignUpProfileViewController *) self parentViewController];
    
    [profile.nextButton addTarget:self action:@selector(gatherInfo) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField addTarget:self action:@selector(checkForContent:) forControlEvents:UIControlEventEditingChanged];

}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    self.is_filled = [self checkForContent:theTextField];
}

-(BOOL)checkForContent:(UITextField *)theTextField
{
    SignUpViewController  *signUpViewController = (SignUpViewController *) self.parentViewController;
    
    //if all fields are not empty show next button
    int first_length = [self.first.text length];
    int last_length = [self.last.text length];

    if (first_length >= 2 && last_length >= 2)
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


-(BOOL) textFieldShouldReturn:(UITextField *)theTextField
{
    
    if(theTextField == self.first)
    {
        [self.first resignFirstResponder];
        [self.last becomeFirstResponder];
    }
    if(theTextField == self.last)
    {
     self.is_filled = [self checkForContent:theTextField];
    if (self.is_filled)
    {
    [self gatherInfo];
    }
    }
    
    return YES;
}

-(void)gatherInfo
{
    
    [shnack_user_info setObject:self.first.text forKey:@"first"];
    [shnack_user_info setObject:self.last.text forKey:@"last"];
    NSLog(@"first: %@, last: %@",[shnack_user_info objectForKey:@"first"],[shnack_user_info objectForKey:@"last"]);
    [self.parentViewController performSegueWithIdentifier:@"next" sender:self];

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
