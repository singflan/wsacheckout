//
//  CompassView.m
//  WSACheckOut
//
//  Created by Timothy England on 9/10/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "CompassView.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation CompassView

@synthesize locationManager;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //Compass Image
        UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        arrowImg.image = [UIImage imageNamed:@"compassArrow"];
        
        //Compass Container
        compassContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:compassContainer];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate=self;
//        
//        //Start the compass updates.
//        [self.locationManager startUpdatingHeading];
        [compassContainer addSubview:arrowImg];

        //Allow other controllers to turn the compass on and off.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdating) name:@"CompassStopUpdating" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdating) name:@"CompassStartUpdating" object:nil];
        
        
    }
    return self;
}

- (void) startUpdating
{
    NSLog(@"starting");
    
    [self.locationManager startUpdatingHeading];
}

- (void) stopUpdating
{
    NSLog(@"Stopping");
    
    [self.locationManager stopUpdatingHeading];
}

#pragma mark -
#pragma mark Geo Points methods

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
	NSInteger magneticAngle = newHeading.magneticHeading;
    NSInteger trueAngle = newHeading.trueHeading;
    
    //This is set by a switch in my apps settings //
    
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    BOOL magneticNorth = [prefs boolForKey:@"UseMagneticNorth"];
    
    if (magneticNorth == YES) {
        
//        NSLog(@"using magnetic north");
//        NSLog(@"New magnetic heading: %ld", (long)magneticAngle);
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(degreesToRadians(-magneticAngle));
        [compassContainer setTransform:rotate];
    }
    
    else {
        
//        NSLog(@"using true north");
//        NSLog(@"New true heading: %ld", (long)trueAngle);
        
        CGAffineTransform rotate = CGAffineTransformMakeRotation(degreesToRadians(-trueAngle));
        [compassContainer setTransform:rotate];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompassStopUpdating" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CompassStartUpdating" object:nil];
}

@end