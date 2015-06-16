//
//  CulturalViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/23/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class Cultural;

@interface CulturalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *reportDisturbList;
@property (strong, nonatomic) NSArray *selectedCultural;

@property (strong, nonatomic) Report *theCurrentReport;
@property (strong, nonatomic) Cultural *theCurrentCultural;

- (IBAction)addCultural:(id)sender;

@end
