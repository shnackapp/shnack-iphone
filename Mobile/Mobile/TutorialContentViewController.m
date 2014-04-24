//
//  TutorialContentViewController.m
//  Mobile
//
//  Created by Spencer Neste on 4/7/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "TutorialContentViewController.h"

@interface TutorialContentViewController ()


@end

@implementation TutorialContentViewController

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
    
    self.iconImageView.image = [UIImage imageNamed:self.imageFile];
    
    self.blurbLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.blurbLabel.numberOfLines = 0;
    self.blurbLabel.text = self.blurbText;
    self.blurbLabel.font = [UIFont fontWithName:@"Poiret One" size:18];

    self.TopLabel.text = self.TopText;
    self.TopLabel.font = [UIFont fontWithName:@"Damion" size:40];

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
