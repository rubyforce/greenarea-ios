//
//  FTCameraViewController.h
//  Green Area 1.0
//
//  Created by DmVolk on 20.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTContentViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FTGreenAreaHTTPClient.h"

@interface FTCameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, FTGreenAreaHTTPClientDelegate>

@end
