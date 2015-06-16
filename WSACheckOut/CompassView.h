//
//  CompassView.h
//  WSACheckOut
//
//  Created by Timothy England on 9/10/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CompassView : UIView <CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;
    CGFloat currentAngle;
    
    UIView *compassContainer;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end