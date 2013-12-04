//
//  FTAppDelegate.m
//  Green Area 1.0
//
//  Created by DmVolk on 13.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTAppDelegate.h"
#import <AKTabBarController.h>

#import "FTProfileViewController.h"
#import "FTDiscoverViewController.h"
#import "FTCameraViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@implementation FTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyA7Z4hrsSVH5_p9qvit_TGd6J9AYCTycTI"];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 50];
    
    [_tabBarController setMinimumHeightToDisplayTitle:40.0];
    
    FTDiscoverViewController *discoverViewController = [[FTDiscoverViewController alloc] init];
    FTCameraViewController *cameraViewController = [[FTCameraViewController alloc] init];
    FTProfileViewController *profileViewController = [[FTProfileViewController alloc] init];
    
    UINavigationController *navDiscoverViewController = [[UINavigationController alloc] initWithRootViewController:discoverViewController];
    UINavigationController *navCameraViewController = [[UINavigationController alloc]initWithRootViewController:cameraViewController];
    UINavigationController *navProfileViewController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1]];
    
    UIColor *nameColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont : [UIFont fontWithName: @"Avenir-Medium" size:20.0], UITextAttributeTextColor : nameColor}];
    
    
    [_tabBarController setViewControllers:[NSMutableArray arrayWithObjects:
                                           navDiscoverViewController,
                                           navCameraViewController,
                                           navProfileViewController,
                                           nil]];
    
    [_tabBarController setBackgroundImageName:@"noise-dark-gray.png"];
    [_tabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
    
    self.window.rootViewController = _tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
