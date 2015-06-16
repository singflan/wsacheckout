//
//  Disturbances.h
//  WSACheckOut
//
//  Created by Timothy England on 1/15/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface Disturbances : NSManagedObject

@property (nonatomic, retain) NSString * disturbDescription;
@property (nonatomic, retain) NSNumber * disturbGPSLatitude;
@property (nonatomic, retain) NSNumber * disturbGPSLongitude;
@property (nonatomic, retain) NSString * disturbImpact;
@property (nonatomic, retain) NSData * disturbPhoto;
@property (nonatomic, retain) NSDate * disturbDateTime;
@property (nonatomic, retain) Report *reported;

@end
