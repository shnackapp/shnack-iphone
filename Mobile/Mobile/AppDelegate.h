//
//  AppDelegate.h
//  Mobile
//
//  Created by Spencer Neste on 2/13/14.
//  Copyright (c) 2014 shnack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import <FacebookSDK/FacebookSDK.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int currentStadium;

@property BOOL uses_keychain;
extern NSMutableDictionary *fb_user_info;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
