//
//  FTShadowView.m
//  ParallaxWithUITableViewStyleGrouped
//
//  Created by DmVolk on 19.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTShadowView.h"

@implementation FTShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
        CAGradientLayer *l = [CAGradientLayer layer];
        l.frame = self.bounds;
        l.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        l.startPoint = CGPointMake(0.0f, 1.0f);
        l.endPoint = CGPointMake(0.0f, 0.0f);
        self.layer.mask = l;
    }
    return self;
}

@end
