//
//  Report.h
//  WSACheckOut
//
//  Created by Timothy England on 2/4/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cultural, Disturbances, KOP, PlantLife, User, Visitors, WildLife, WorkRequired;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSString * areaMonitored;
@property (nonatomic, retain) NSString * blmDistrict;
@property (nonatomic, retain) NSString * culturalStatus;
@property (nonatomic, retain) NSDate * dateTimeStamp;
@property (nonatomic, retain) NSString * disturbStatus;
@property (nonatomic, retain) NSString * handle4WD;
@property (nonatomic, retain) NSString * monitorConducted;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * plantStatus;
@property (nonatomic, retain) NSString * reportStatus;
@property (nonatomic, retain) NSString * reportTitle;
@property (nonatomic, retain) NSString * visitorsStatus;
@property (nonatomic, retain) NSString * wildlifeStatus;
@property (nonatomic, retain) NSString * workStatus;
@property (nonatomic, retain) NSString * wsaName;
@property (nonatomic, retain) User *createdReport;
@property (nonatomic, retain) NSOrderedSet *sawCultural;
@property (nonatomic, retain) NSOrderedSet *sawDisturbances;
@property (nonatomic, retain) NSOrderedSet *sawPlantLife;
@property (nonatomic, retain) Visitors *sawVisitors;
@property (nonatomic, retain) NSOrderedSet *sawWildLife;
@property (nonatomic, retain) NSOrderedSet *sawWorkRequired;
@property (nonatomic, retain) NSOrderedSet *tookKOPs;
@end

@interface Report (CoreDataGeneratedAccessors)

- (void)insertObject:(Cultural *)value inSawCulturalAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSawCulturalAtIndex:(NSUInteger)idx;
- (void)insertSawCultural:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSawCulturalAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSawCulturalAtIndex:(NSUInteger)idx withObject:(Cultural *)value;
- (void)replaceSawCulturalAtIndexes:(NSIndexSet *)indexes withSawCultural:(NSArray *)values;
- (void)addSawCulturalObject:(Cultural *)value;
- (void)removeSawCulturalObject:(Cultural *)value;
- (void)addSawCultural:(NSOrderedSet *)values;
- (void)removeSawCultural:(NSOrderedSet *)values;
- (void)insertObject:(Disturbances *)value inSawDisturbancesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSawDisturbancesAtIndex:(NSUInteger)idx;
- (void)insertSawDisturbances:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSawDisturbancesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSawDisturbancesAtIndex:(NSUInteger)idx withObject:(Disturbances *)value;
- (void)replaceSawDisturbancesAtIndexes:(NSIndexSet *)indexes withSawDisturbances:(NSArray *)values;
- (void)addSawDisturbancesObject:(Disturbances *)value;
- (void)removeSawDisturbancesObject:(Disturbances *)value;
- (void)addSawDisturbances:(NSOrderedSet *)values;
- (void)removeSawDisturbances:(NSOrderedSet *)values;
- (void)insertObject:(PlantLife *)value inSawPlantLifeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSawPlantLifeAtIndex:(NSUInteger)idx;
- (void)insertSawPlantLife:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSawPlantLifeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSawPlantLifeAtIndex:(NSUInteger)idx withObject:(PlantLife *)value;
- (void)replaceSawPlantLifeAtIndexes:(NSIndexSet *)indexes withSawPlantLife:(NSArray *)values;
- (void)addSawPlantLifeObject:(PlantLife *)value;
- (void)removeSawPlantLifeObject:(PlantLife *)value;
- (void)addSawPlantLife:(NSOrderedSet *)values;
- (void)removeSawPlantLife:(NSOrderedSet *)values;
- (void)insertObject:(WildLife *)value inSawWildLifeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSawWildLifeAtIndex:(NSUInteger)idx;
- (void)insertSawWildLife:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSawWildLifeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSawWildLifeAtIndex:(NSUInteger)idx withObject:(WildLife *)value;
- (void)replaceSawWildLifeAtIndexes:(NSIndexSet *)indexes withSawWildLife:(NSArray *)values;
- (void)addSawWildLifeObject:(WildLife *)value;
- (void)removeSawWildLifeObject:(WildLife *)value;
- (void)addSawWildLife:(NSOrderedSet *)values;
- (void)removeSawWildLife:(NSOrderedSet *)values;
- (void)insertObject:(WorkRequired *)value inSawWorkRequiredAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSawWorkRequiredAtIndex:(NSUInteger)idx;
- (void)insertSawWorkRequired:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSawWorkRequiredAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSawWorkRequiredAtIndex:(NSUInteger)idx withObject:(WorkRequired *)value;
- (void)replaceSawWorkRequiredAtIndexes:(NSIndexSet *)indexes withSawWorkRequired:(NSArray *)values;
- (void)addSawWorkRequiredObject:(WorkRequired *)value;
- (void)removeSawWorkRequiredObject:(WorkRequired *)value;
- (void)addSawWorkRequired:(NSOrderedSet *)values;
- (void)removeSawWorkRequired:(NSOrderedSet *)values;
- (void)insertObject:(KOP *)value inTookKOPsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTookKOPsAtIndex:(NSUInteger)idx;
- (void)insertTookKOPs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTookKOPsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTookKOPsAtIndex:(NSUInteger)idx withObject:(KOP *)value;
- (void)replaceTookKOPsAtIndexes:(NSIndexSet *)indexes withTookKOPs:(NSArray *)values;
- (void)addTookKOPsObject:(KOP *)value;
- (void)removeTookKOPsObject:(KOP *)value;
- (void)addTookKOPs:(NSOrderedSet *)values;
- (void)removeTookKOPs:(NSOrderedSet *)values;
@end
