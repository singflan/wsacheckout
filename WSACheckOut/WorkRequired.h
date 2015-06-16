//
//  WorkRequired.h
//  WSACheckOut
//
//  Created by Timothy England on 1/27/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface WorkRequired : NSManagedObject

@property (nonatomic, retain) NSNumber * workGPSLatitude;
@property (nonatomic, retain) NSNumber * workGPSLongitude;
@property (nonatomic, retain) NSData * workPhoto;
@property (nonatomic, retain) NSString * workRequired;
@property (nonatomic, retain) NSDate * workDateTime;
@property (nonatomic, retain) Report *reported;

@end
