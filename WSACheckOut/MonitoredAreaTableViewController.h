//
//  MonitoredAreaSelectViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 8/28/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;

@protocol MonitoredAreaSelectViewControllerDelegate <NSObject>

-(void) loadReport:(Report *)report;

@end

@interface MonitoredAreaTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <MonitoredAreaSelectViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *selectedMonitoredArea;
@property (strong, nonatomic) NSString *selectedFieldOffice;
@property (strong, nonatomic) NSArray *areasArray;
@property (strong, nonatomic) NSMutableArray *workingArray;
@property (strong, nonatomic) NSSet *uniqueAreas;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) Report *theNewReport;

@end
