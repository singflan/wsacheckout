//
//  GPSCoordinates.m
//  WSACheckOut
//
//  Created by Timothy England on 4/21/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "GPSCoordinates.h"

@implementation GPSCoordinates


+ (NSString *) WithLatitude:(double)latitude WithLongitude:(double)longitude {
    
    int latSeconds = (int)round(fabs(latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = latSeconds % 3600;
    int latMinutes = latSeconds / 60;
    latSeconds %= 60;
    
    int longSeconds = (int)round(fabs(longitude * 3600));
    int longDegrees = longSeconds / 3600;
    longSeconds = longSeconds % 3600;
    int longMinutes = longSeconds / 60;
    longSeconds %= 60;
    
    char latDirection = (latitude > 0) ? 'N' : 'S';
    char longDirection = (longitude > 0) ? 'E' : 'W';
    
    return [NSString stringWithFormat:@"%i° %i' %i\" %c, %i° %i' %i\" %c", latDegrees, latMinutes, latSeconds, latDirection, longDegrees, longMinutes, longSeconds, longDirection];

}

@end
