//
//  UILine.m
//  WSACheckOut
//
//  Created by Timothy England on 5/7/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "UILine.h"

@implementation UILine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        {
        // careful, contentScaleFactor does not work
        // in storyboard during initWithCoder:
        // float sortaPixel = 1.0/self.contentScaleFactor;
        // instead, use mainScreen scale which works perfectly:
        float sortaPixel = 1.0/[UIScreen mainScreen].scale;
        UIView *topSeparatorView = [[UIView alloc] initWithFrame:
                                    CGRectMake(0, 0, self.frame.size.width, sortaPixel)];
        [topSeparatorView setBackgroundColor:self.backgroundColor];
        [self addSubview:topSeparatorView];
        self.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

@end
