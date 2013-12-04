//
//  FTProfileViewController.h
//  Green Area 1.0
//
//  Created by DmVolk on 20.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIView *secondParaView;
@property (strong, nonatomic) UIView *nameView;

@end
