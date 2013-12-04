//
//  FTTextField.m
//  Green Area 1.0
//
//  Created by DmVolk on 06.11.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTTextField.h"

@implementation FTTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + self.horizontalPadding,
                      bounds.origin.y + self.verticalPadding,
                      bounds.size.width - self.horizontalPadding * 2,
                      bounds.size.height - self.verticalPadding * 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
