//
//  FTDiscoverViewController.h
//  Green Area 1.0
//
//  Created by DmVolk on 20.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTGreenAreaHTTPClient.h"
#import <GoogleMaps/GoogleMaps.h>

@interface FTDiscoverViewController : UIViewController <FTGreenAreaHTTPClientDelegate, GMSMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) NSArray *pins;

@end
