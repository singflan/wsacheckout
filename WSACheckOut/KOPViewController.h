//
//  KOPViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 8/29/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;

@interface KOPViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Report *theCurrentReport;

- (IBAction)addKOP:(id)sender;

@end
