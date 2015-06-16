//
//  UYLStyleController.m
//  WSACheckOut
//
//  Created by Timothy England on 9/2/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "UYLStyleController.h"
#import "LoginController.h"
#import "CreateLoginViewController.h"

@implementation UYLStyleController

+ (void)applyStyle {
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont fontWithName:@"Avenir-Heavy" size:18.0], NSFontAttributeName, nil]];
    
    [[UITabBar appearance] setTintColor:[UIColor midnightBlueColor]];
    
}

@end
