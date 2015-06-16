//
//  DisturbViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 9/30/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class Disturbances;

@interface DisturbViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *reportDisturbList;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSArray *selectedDisturb;

@property (strong, nonatomic) Report *theCurrentReport;
@property (strong, nonatomic) Disturbances *theCurrentDisturbance;

- (IBAction)addDisturbance:(id)sender;

@end
