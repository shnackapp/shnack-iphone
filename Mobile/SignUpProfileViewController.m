//
//  SignUpProfileViewController.m
//  Mobile
//
//  Created by Spencer Neste on 7/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpProfileViewController.h"
#import "ProfileContainerViewController.h"

@interface SignUpProfileViewController ()

@end

@implementation SignUpProfileViewController

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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;
    
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Profile", @"");
    [label sizeToFit];
    
    
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.signUpTitle.font = [UIFont fontWithName:@"Dosis-Medium" size:26];
    
    self.nextButton.enabled = NO;
    
    self.container.layer.cornerRadius = 5.0f;

    

    // Do any additional setup after loading the view.
}

-(IBAction)next
{
    ProfileContainerViewController *profileContainer = (ProfileContainerViewController *) self.childViewControllers[0];
    [profileContainer gatherInfo];
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
