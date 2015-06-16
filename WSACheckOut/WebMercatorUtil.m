//
//  WebMercatorUtil.m
//  iphoneGPS
//
//

#import "WebMercatorUtil.h"


@implementation WebMercatorUtil

+ (double)toWebMercatorY:(double)latitude
{
	double rad = latitude * 0.0174532;
	double fsin = sin(rad);
	
	double y = 6378137 / 2.0 * log((1.0 + fsin) / (1.0 - fsin));
	
	return y;
}


+ (double)toWebMercatorX:(double)longitude
{
	double x = longitude * 0.017453292519943 * 6378137;
	
	return x;
}
@end
