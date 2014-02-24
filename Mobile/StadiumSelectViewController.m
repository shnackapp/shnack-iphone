////
////  StadiumSelectViewController.m
////  Mobile
////
////  Created by Spencer Neste on 2/15/14.
////  Copyright (c) 2014 shnack. All rights reserved.
////
//
//#import "StadiumSelectViewController.h"
//#import "ObjectWithNameAndID.h"
//
//@interface StadiumSelectViewController ()
//
//@end
//
//@implementation StadiumSelectViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    
//    return 1;
//}
//
//// returns the # of rows in each component..
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
//{
//    if(pickerView == self.stadiumPicker)
//    {
//        return [self.Stadia count];
//    }
//    return -1;
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
//{
//    if(pickerView == self.stadiumPicker)
//    {
//        return [self.Stadia[row] name];
//    }
//    return nil;
//}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
//{
//    NSLog(@"did select row");
//    
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//    
//    
////    VendorAppDelegate *appDelegate = (VendorAppDelegate *)[[UIApplication sharedApplication] delegate];
////    
////    
////    NSString *bodyData = [NSString stringWithFormat:@"auth_token=%@", appDelegate.userToken];
////    NSString *url = [NSString stringWithFormat:@"%@vendors_by_user_token", BASE_URL];
////    NSString *api_key = [NSString stringWithFormat:@"Token token=\"%@\"", ACCESS_TOKEN];
////    
////    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
////    
////    [postRequest setValue:api_key forHTTPHeaderField:@"Authorization"];
////    [postRequest setHTTPMethod:@"POST"];
////    
////    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
////    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
////    
////    
////    _receivedData = [NSMutableData dataWithCapacity: 0];
////    
////    NSLog(@"Connection is %@", theConnection);
////    if (!theConnection) {
////        // Release the receivedData object.
////        _receivedData = nil;
////        
////        // Inform the user that the connection failed.
////    }
//    
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//
//#pragma mark NSURLConnectionDelegate methods
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    // A response has been received, this is where we initialize the instance var you created
//    // so that we can append data to it in the didReceiveData method
//    // Furthermore, this method is called each time there is a redirect so reinitializing it
//    // also serves to clear it
//    //    NSLog(@"got to didReceiveResponse: %@", response);
//    [_receivedData setLength:0];
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    // Append the new data to the instance variable you declared
//    [_receivedData appendData:data];
//}
//
//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
//                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
//    // Return nil to indicate not necessary to store a cached response for this connection
//    return nil;
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    // The request is complete and data has been received
//    // You can parse the stuff in your instance variable now
//    
//    NSError *error = nil;
//    //    NSString *receivedJSON = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
//    NSArray *receivedJSON = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"data is %@", receivedJSON);
//    self.Stadia = [[NSMutableArray alloc] initWithCapacity:[receivedJSON count]];
//    
//    
//    for(NSDictionary *item in receivedJSON) {
//        int id_ = [[item objectForKey:@"id"] integerValue];
//        NSString *name = [item valueForKey:@"name"];
//        ObjectWithNameAndID *aStadium = [[ObjectWithNameAndID alloc] initWithID:id_ name:name];
//        NSLog(@"stadium name is %@",aStadium.name);
//        NSLog(@"id name is %d",aStadium.object_id);
//
//        [self.Stadia addObject: aStadium];
//    }
//    
//    [self.stadiumPicker reloadAllComponents];
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    // The request has failed for some reason!
//    // Check the error var
//    
//    // Release the connection and the data object
//    // by setting the properties (declared elsewhere)
//    // to nil.  Note that a real-world app usually
//    // requires the delegate to manage more than one
//    // connection at a time, so these lines would
//    // typically be replaced by code to iterate through
//    // whatever data structures you are using.
//    //    theConnection = nil;
//    _receivedData = nil;
//    
//    // inform the user
//    NSLog(@"Connection failed! Error - %@ %@",
//          [error localizedDescription],
//          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
//}
//
//
//@end
//
//
//
//
//
