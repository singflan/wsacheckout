//
//  WildlifeViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/16/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class WildLife;

@interface WildlifeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *reportWildlifeList;

@property (strong, nonatomic) Report *theCurrentReport;
@property (strong, nonatomic) WildLife *theCurrentWildlife;

- (IBAction)addWildlife:(id)sender;

@end