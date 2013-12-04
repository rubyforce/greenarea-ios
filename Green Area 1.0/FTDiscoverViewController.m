//
//  FTDiscoverViewController.m
//  Green Area 1.0
//
//  Created by DmVolk on 20.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTDiscoverViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FTDescriptionViewController.h"
#import <SVProgressHUD.h>

@interface FTDiscoverViewController ()

@property(nonatomic, strong) UIBarButtonItem *updateBarButton;

@end

@implementation FTDiscoverViewController

{
    GMSMapView *mapView_;
    CLLocation *currentLocation_;
}

-(id)init
{
    self = [super init];
    if (self) {
        self.title = @"";
    }
    return self;
}

-(NSString *)tabImageName
{
    return @"image-2";
}

-(NSString *)tabTitle
{
    return @"Discover";
}

//не реализован в текущей версии UIViewController+AKTabBarController.h
//- (NSString *)tabBackgroundImageName {
//    return @"noise-dark-green.png";
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Google Map View
    mapView_ = [[GMSMapView alloc] initWithFrame:CGRectZero];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.delegate = self;
    self.view = mapView_;
    
    //location manager
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 50.0f;
    [_locationManager startUpdatingLocation];
    
    [self updatePins];
    
    self.updateBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updatePins)];
    self.updateBarButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.updateBarButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updatePins
{
    NSLog(@"Refresh pins");
    
    //show loading progress for pins updating
    [SVProgressHUD showWithStatus:@"Updating pins"];
    
    self.updateBarButton.enabled = NO;
    
    self.title = @"Updating pins";
    
    //HTTPClient
    FTGreenAreaHTTPClient *client = [FTGreenAreaHTTPClient sharedFTGreenAreaHTTPClient];
    client.delegate = self;
    [client updatePins];
}

-(void)addMarkerToPosition:(CLLocationCoordinate2D)position title:(NSString *)title snippet:(NSString *)snippet mapView:(GMSMapView *)mapView
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = position;
    marker.title = title;
    marker.snippet = snippet;
    marker.map = mapView;
}


#pragma mark GreenAreaHTTPClient Delegate Methods

-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client didUpdateWithPins:(id)pins
{
    //show success for pins updating
    [SVProgressHUD showSuccessWithStatus:@"Pins Updated"];
    
    self.updateBarButton.enabled = YES;
    
    self.title = @"Pins Updated";
    
    self.pins = (NSArray *)pins;
    NSLog(@"%@", self.pins);
    
    for (NSDictionary *dict in self.pins) {
        
        CLLocationCoordinate2D lc = CLLocationCoordinate2DMake([[dict objectForKey:@"latitude"] doubleValue],
                                                               [[dict objectForKey:@"longitude"] doubleValue]);
        NSString *title = [dict objectForKey:@"title"];
        
        [self addMarkerToPosition:lc title:title snippet:nil mapView:mapView_];
    }
}

-(void)greenAreaHTTPClient:(FTGreenAreaHTTPClient *)client didFailWithError:(NSError *)error
{
    //show error for pins updating
    [SVProgressHUD showErrorWithStatus:@"Failed with Error"];
    
    self.updateBarButton.enabled = YES;
    
    self.title = @"Failed with Error";
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error occurred :("
                                                 message:[NSString stringWithFormat:@"Error: %@", error]
                                                delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [av show];
}

-(NSDictionary *)searchInfoForMarker:(GMSMarker *)marker
{
    NSDictionary *result = nil;
    
    NSString *title = marker.title;
    double lat = marker.position.latitude;
    double lon = marker.position.longitude;
    
    double roundedLat = round(lat*pow(10.0f, 3.0f))/pow(10.0f, 3.0f);
    double roundedLon = round(lon*pow(10.0f, 3.0f))/pow(10.0f, 3.0f);
    
    for (NSDictionary *dict in self.pins) {
        
        NSString *pinTitle = [dict objectForKey:@"title"];
        double pinLat = [[dict objectForKey:@"latitude"] doubleValue];
        double pinLon = [[dict objectForKey:@"longitude"] doubleValue];
        
        double roundedPinLat = round(pinLat*pow(10.0f, 3.0f))/pow(10.0f, 3.0f);
        double roundedPinLon = round(pinLon*pow(10.0f, 3.0f))/pow(10.0f, 3.0f);
        
        if ([title isEqualToString:pinTitle] && roundedLat == roundedPinLat && roundedLon == roundedPinLon) {
            return dict;
        }
    }
    return result;
}



#pragma mark GMSMapView Delegate Methods

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSLog(@"Tap!");
    
    NSDictionary *markerInfo = [self searchInfoForMarker:marker];
    
    FTDescriptionViewController *descriptionViewController = [[FTDescriptionViewController alloc] init];
    descriptionViewController.name = [markerInfo valueForKey:@"title"];
    descriptionViewController.imageUrl = [markerInfo valueForKey:@"image_url"];
    
    [self presentViewController:descriptionViewController animated:YES completion:nil];
}

#pragma mark CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    if (newLocation.horizontalAccuracy < 0 /*|| newLocation.verticalAccuracy < 0*/) {
        NSLog(@"Incorrect results of newLocation: horizontal accuracy = %f, vertical accuracy = %f", newLocation.horizontalAccuracy, newLocation.verticalAccuracy);
        return;
    }
    
    if (newLocation.horizontalAccuracy > 50 /*|| newLocation.verticalAccuracy > 50*/) {
        NSLog(@"Incorrect results of newLocation: horizontal accuracy = %f, vertical accuracy = %f", newLocation.horizontalAccuracy, newLocation.verticalAccuracy);
        return;
    }
    
    if (currentLocation_ == nil) {
        [mapView_ setCamera:[GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude zoom:15]];
    }
}

@end
