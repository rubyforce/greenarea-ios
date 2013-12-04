//
//  FTDescriptionViewController.h
//  Green Area 1.0
//
//  Created by DmVolk on 01.11.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTDescriptionViewController : UINavigationController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSString *imageUrl;

@end
