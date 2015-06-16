//
//  PlantLife.h
//  WSACheckOut
//
//  Created by Timothy England on 2/4/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface PlantLife : NSManagedObject

@property (nonatomic, retain) NSDate * plantDateTime;
@property (nonatomic, retain) NSString * plantDescription;
@property (nonatomic, retain) NSNumber * plantGPSLatitude;
@property (nonatomic, retain) NSNumber * plantGPSLongitude;
@property (nonatomic, retain) NSString * plantObserved;
@property (nonatomic, retain) NSData * plantPhoto;
@property (nonatomic, retain) Report *reported;

@end
