//
//  KOP.h
//  WSACheckOut
//
//  Created by Timothy England on 1/23/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface KOP : NSManagedObject

@property (nonatomic, retain) NSDate * kopDateTime;
@property (nonatomic, retain) NSString * kopDescription;
@property (nonatomic, retain) NSNumber * kopGPSLatitude;
@property (nonatomic, retain) NSNumber * kopGPSLongitude;
@property (nonatomic, retain) NSString * kopName;
@property (nonatomic, retain) NSData * kopPhotoE;
@property (nonatomic, retain) NSData * kopPhotoN;
@property (nonatomic, retain) NSData * kopPhotoS;
@property (nonatomic, retain) NSData * kopPhotoW;
@property (nonatomic, retain) NSString * kopStatus;
@property (nonatomic, retain) Report *reported;

@end
