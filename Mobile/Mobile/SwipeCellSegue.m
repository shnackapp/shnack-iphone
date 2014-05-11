//
//  ViewVendorSegue.m
//  Mobile
//
//  Created by Spencer Neste on 2/24/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "SwipeCellSegue.h"

@implementation SwipeCellSegue
- (void)perform
{
    [self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
    
}
@end