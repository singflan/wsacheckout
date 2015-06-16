//
//  WildLife.h
//  WSACheckOut
//
//  Created by Timothy England on 1/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface WildLife : NSManagedObject

@property (nonatomic, retain) NSDate * animalDateTime;
@property (nonatomic, retain) NSString * animalDescription;
@property (nonatomic, retain) NSNumber * animalGPSLatitude;
@property (nonatomic, retain) NSNumber * animalGPSLongitude;
@property (nonatomic, retain) NSString * animalObserved;
@property (nonatomic, retain) NSData * animalPhoto;
@property (nonatomic, retain) Report *reported;

@end
