//
//  Cultural.h
//  WSACheckOut
//
//  Created by Timothy England on 4/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface Cultural : NSManagedObject

@property (nonatomic, retain) NSDate * culturalDateTime;
@property (nonatomic, retain) NSNumber * culturalGPSLatitude;
@property (nonatomic, retain) NSNumber * culturalGPSLongitude;
@property (nonatomic, retain) NSString * culturalObserved;
@property (nonatomic, retain) NSData * culturalPhoto;
@property (nonatomic, retain) NSString * culturalDescription;
@property (nonatomic, retain) Report *reported;

@end
