//
//  PlantsViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/23/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class PlantLife;

@interface PlantsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *reportPlantLifeList;

@property (strong, nonatomic) Report *theCurrentReport;
@property (strong, nonatomic) PlantLife *theCurrentPlantLife;

- (IBAction)addPlantlife:(id)sender;

@end
