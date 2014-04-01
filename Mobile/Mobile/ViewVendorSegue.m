//
//  ViewVendorSegue.m
//  Mobile
//
//  Created by Spencer Neste on 2/24/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "ViewVendorSegue.h"

@implementation ViewVendorSegue
- (void)perform
{
    [self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
}
- (void) sendStadiumId
{
    //self.responseData = [NSMutableData data];//
    //NSLog(@"response data is %@",self.responseData);
    
    
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:3000/api/index"];
    NSString *api_key = [NSString stringWithFormat:@"Token token=\"b2c70bb5d8d2bb35b6b4fcfbc9043d6a\""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];//
    [request setHTTPMethod:@"GET"];
    
    [request setValue:api_key forHTTPHeaderField:@"Authorization"];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];//
    

    
}


@end
