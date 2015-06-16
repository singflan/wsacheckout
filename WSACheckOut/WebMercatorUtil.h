//
//  WebMercatorUtil.h
//  iphoneGPS
//
//  Created by Harikant Jammi on 29/10/10.
//  Copyright 2010 CyberTech Systems & Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

@interface WebMercatorUtil : NSObject {

}
+ (double)toWebMercatorY:(double)latitude;
+ (double)toWebMercatorX:(double)longitude;
@end
