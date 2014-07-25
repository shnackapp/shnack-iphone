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
    
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Poiret One" size:16];
    self.signUpTitle.font = [UIFont fontWithName:@"Poiret One" size:26];
    
    SignUpContainerViewController *signUpContainerViewController
    = (SignUpContainerViewController *)  self.childViewControllers[0];
    NSLog(@"container class %@",signUpContainerViewController.class);
    
    self.error_messages.hidden = YES;
    

    
    //make container round.....
    //signUpContainerViewController.tableView.layer.cornerRadius = 10;

    
}
//makes errors spaced out
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 24; // For really wide spacing; pick your own value
}

-(IBAction)next
{
    SignUpContainerViewController *signUpContainer = (SignUpContainerViewController *) self.childViewControllers[0];
    [signUpContainer gatherAndCheckForm];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
