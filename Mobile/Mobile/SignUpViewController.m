//
//  SignUpViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpViewController.h"
#import "CustomUnwindSegue.h"
#import "InitialViewController.h"

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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.doneButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.signUpTitle.font = [UIFont fontWithName:@"Poiret One" size:26];
    
    self.forgotPassword.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];

    
}

-(IBAction)home
{
    NSLog(@"clikced cancel");

    [self performSegueWithIdentifier:@"Unwind" sender:self];

    
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
