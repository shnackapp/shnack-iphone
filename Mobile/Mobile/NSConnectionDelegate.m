////
////  NSConnectionDelegate.m
////  Mobile
////
////  Created by Spencer Neste on 2/13/14.
////  Copyright (c) 2014 shnack. All rights reserved.
////This is for ordering
//
//#import "NSConnectionDelegate.h"
//#define ACCESS_TOKEN @"b2c70bb5d8d2bb35b6b4fcfbc9043d6a"
//#define BASE_URL @"http://shnack.herokuapp.com/"
//
//
//@implementation NSConnectionDelegate
//
////Shnack Methods
//-(IBAction)login:(id)sender
//{
//    //Send Log in, synchronous request
//    NSLog(@"login button pressed");
//    NSString *bodyData = [NSString stringWithFormat:@"email=%@&password=%@", [self.usernameField text] ,[self.passwordField text]];
//    NSString *url = [NSString stringWithFormat:@"%@login", BASE_URL];
//    NSString *api_key = [NSString stringWithFormat:@"Token token=\"%@\"", ACCESS_TOKEN];
//    
//    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
//    
//    [postRequest setValue:api_key forHTTPHeaderField:@"Authorization"];
//    [postRequest setHTTPMethod:@"POST"];
//    
//    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    
//    //    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
//    _receivedData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
//    
//    NSString *receivedJSON = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
//    NSLog(@"data is %@", receivedJSON);
//    
//    
//    //Handle Error here
//    if(error)
//    {
//        NSLog(@"Error: %@", error);
//    }
//    
//    //    _receivedData = [NSMutableData dataWithCapacity: 0];
//    
//    //    NSLog(@"Connection is %@", connection);
//    //    if (!connection) {
//    //        // Release the receivedData object.
//    //        _receivedData = nil;
//    //
//    //        // Inform the user that the connection failed.
//    //    }
//    
//    
//    //If authorized, check if device is registered, synchronous request
//    
//    //If not registered - load do you want to register view?
//    
//    //If registered, load order table.
//}
//
//@end
