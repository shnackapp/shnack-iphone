//
//  DetailViewController.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "VendorViewController.h"

@interface VendorViewController ()
- (void)configureView;
@end

@implementation VendorViewController

#pragma mark - Managing the Vendor item

- (void)setVendorItem:(id)newVendorItem
{
    if (_vendorItem != newVendorItem) {
        _vendorItem = newVendorItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.vendorItem) {
        self.vendorDescriptionLabel.text = [[self.vendorItem valueForKey:@"timeStamp"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
