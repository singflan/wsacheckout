//
//  Visitors.h
//  WSACheckOut
//
//  Created by Timothy England on 1/24/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface Visitors : NSManagedObject

@property (nonatomic, retain) NSString * encounteredNumber;
@property (nonatomic, retain) NSString * encounteredYesNo;
@property (nonatomic, retain) Report *reported;

@end
