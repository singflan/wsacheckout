//
//  GPSCoordinates.h
//  WSACheckOut
//
//  Created by Timothy England on 4/21/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSCoordinates : NSObject

+(NSString *) WithLatitude:(double)latitude
             WithLongitude:(double)longitude;

@end
