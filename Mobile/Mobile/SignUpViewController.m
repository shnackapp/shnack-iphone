//
//  SignUpViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/21/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SignUpViewController.h"

#import "SignUpContainerViewController.h"
#import "InitialViewController.h"
#import "MBProgressHUD.h"
#import "DismissSegue.h"
#import <QuartzCore/QuartzCore.h>


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
    
    self.loginView.delegate = self;
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    self.container.layer.cornerRadius = 5.0f;

    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Dosis-Medium" size:22];;

    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Sign Up", @"");
    [label sizeToFit];
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.cancelButton.titleLabel.textColor  = [UIColor whiteColor];
    [self.cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Dosis-Bold" size:16];
    self.nextButton.enabled = NO;
    self.signUpTitle.font = [UIFont fontWithName:@"Dosis-Medium" size:26];
    
    SignUpContainerViewController *signUpContainerViewController
    = (SignUpContainerViewController *)  self.childViewControllers[0];
    NSLog(@"container class %@",signUpContainerViewController.class);
    
    self.error_messages.hidden = YES;

    
}

-(void) dismiss
{
    [self performSegueWithIdentifier:@"dismiss" sender:self];
    
}
//makes errors spaced out
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 24; // For really wide spacing; pick your own value
}

-(IBAction)next
{
    
    SignUpContainerViewController *signUpContainer = (SignUpContainerViewController *) self.childViewControllers[0];

   BOOL shouldSegue =  [signUpContainer gatherAndCheckForm];

    
    if (shouldSegue)
    {
        NSLog(@"print me");
        [self performSegueWithIdentifier:@"next" sender:self];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    
//    if([segue.identifier isEqualToString:@"next"])
//    {
//        NSLog(@"welllllll");
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
