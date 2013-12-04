//
//  FTAppDelegate.h
//  Green Area 1.0
//
//  Created by DmVolk on 13.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AKTabBarController;

@interface FTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) AKTabBarController *tabBarController;

@end
