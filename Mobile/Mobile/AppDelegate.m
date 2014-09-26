//
//  AppDelegate.m
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationsViewController.h"
#import "RESideMenu.h"
#import "LeftMenuViewController.h"
#import "RightMenuViewController.h"
#import "SignUpNavController.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"appDelegate");

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    
    [FBLoginView class];
    fb_user_info = [[NSMutableDictionary alloc] initWithCapacity:1];
    shnack_user_info = [[NSMutableDictionary alloc] initWithCapacity:8];
  
    KeychainItemWrapper *password = [[KeychainItemWrapper alloc] initWithIdentifier:@"password" accessGroup:nil];
    [password setObject:@"password" forKey: (__bridge id)kSecAttrService];
    [password setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *email = [[KeychainItemWrapper alloc] initWithIdentifier:@"email" accessGroup:nil];
    [email setObject:@"email" forKey: (__bridge id)kSecAttrService];
    [email setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *name = [[KeychainItemWrapper alloc] initWithIdentifier:@"name" accessGroup:nil];
    [name setObject:@"name" forKey: (__bridge id)kSecAttrService];
    [name setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *phone = [[KeychainItemWrapper alloc] initWithIdentifier:@"phone" accessGroup:nil];
    [phone setObject:@"phone" forKey: (__bridge id)kSecAttrService];
    [phone setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
    KeychainItemWrapper *token = [[KeychainItemWrapper alloc] initWithIdentifier:@"token" accessGroup:nil];
    [token setObject:@"token" forKey: (__bridge id)kSecAttrService];
    [token setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)(kSecAttrAccessible)];
  
  NSInteger l1 = [[password objectForKey:(__bridge id)(kSecValueData)] length];
  NSInteger l2 = [[email objectForKey:(__bridge id)(kSecValueData)] length];
  NSInteger l3 = [[name objectForKey:(__bridge id)(kSecValueData)] length];
  NSInteger l4 = [[phone objectForKey:(__bridge id)(kSecValueData)] length];
  NSInteger l5 = [[token objectForKey:(__bridge id)(kSecValueData)] length];

  
  
  
  
  

      // Whenever a person opens the app, check for a cached FACEBOOK session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
      uses_keychain = NO;
      uses_facebook = YES;

    }
    //otherwise check the keychain for credentials
    else if (l1 != 0 && l2 != 0 && l3 != 0 && l4 != 0 &&l5 != 0)
    {
      
        NSLog(@"PASSWORD: %@",password);
        NSLog(@"EMAIL: %@", email );
        NSLog(@"NAME: %@",name);
        NSLog(@"PHONE: %@",phone);
        NSLog(@"TOKEN: %@", token);
      
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        
        RootViewController *root =(RootViewController*)[mainStoryboard
                                                        instantiateViewControllerWithIdentifier: @"root"];
        self.window.rootViewController = root;
        [self.window makeKeyAndVisible];
        
        NSLog(@"i should segue to menu page");
        uses_keychain = YES;
        uses_facebook = NO;
        

    }
    //if none are populated, then segue normally to initial (do nothing)
    else
    {
        NSLog(@"no fb or keychain");
      uses_facebook = NO;
      uses_keychain = NO;
    }
    
    
  
    // Override point for customization after application launch.
    //UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    //StadiumViewController *controller = (StadiumViewController *)navigationController.topViewController;
    //controller.managedObjectContext = self.managedObjectContext;
    return YES;
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    /* make the API call */
//    [FBRequestConnection startWithGraphPath:@"/me"
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              /* handle the result */
//                              NSLog(@"THIS IS result %@", result);
//                              [fb_user_info setValue:result forKey:@"result"];
//                              uses_facebook = YES;
//                              uses_keychain = NO;
//                          }];
  NSLog(@"login with facebook button clicked!");
  
  
  
  return wasHandled;
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    
    // Confirm logout message
   // [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Welcome message
    [FBRequestConnection startWithGraphPath:@"/me"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSLog(@"THIS IS result %@", result);
                              [fb_user_info setValue:result forKey:@"result"];
                              uses_facebook = YES;
                              uses_keychain = NO;
                          }];
    
  NSLog(@"im in here2");
    //maybe here instead present the verify page because we need phone number
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
  
  RootViewController *root =(RootViewController*)[mainStoryboard
                  instantiateViewControllerWithIdentifier: @"root"];
  
  
  AccountTableViewController *account =(AccountTableViewController*)[mainStoryboard
                  instantiateViewControllerWithIdentifier: @"account"];
  account.email.text = [[fb_user_info valueForKey:@"result"] valueForKey:@"email"];
  account.name.text = [[fb_user_info valueForKey:@"result"] valueForKey:@"name"];

  
    self.window.rootViewController = account;
    [self.window makeKeyAndVisible];

    [self showMessage:@"You're now logged in, but first we need you to verify some info!" withTitle:@"Welcome!"];
  
  
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mobile" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mobile.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
