//
//  LoginContainerViewController.m
//  Mobile
//
//  Created by Spencer Neste on 5/28/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "LoginContainerViewController.h"

@interface LoginContainerViewController ()

@end

@implementation LoginContainerViewController

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
    

    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.loginTitle.font = [UIFont fontWithName:@"Poiret One" size:26];
    
    self.forgotPassword.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    



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
