//
//  FTAboutViewController.m
//  Green Area 1.0
//
//  Created by DmVolk on 06.11.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTAboutViewController.h"

@interface FTAboutViewController ()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation FTAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *aboutImageName = @"about-logo.png";
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (screenRect.size.height == 568.0f) {
        aboutImageName = [aboutImageName stringByReplacingOccurrencesOfString:@".png" withString:@"-568h.png"];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:aboutImageName]];
        self.imageView.frame = CGRectMake(0.0, 0.0, 320.0, 504.0);
    } else {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:aboutImageName]];
        self.imageView.frame = CGRectMake(0.0, 0.0, 320.0, 416.0);
    }
    
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
