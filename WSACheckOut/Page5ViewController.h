//
//  Page5ViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/17/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;

@interface Page5ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *page5Title;

@property (strong, nonatomic) IBOutlet UISwitch *culturalSwitch;

@property (strong, nonatomic) Report *theCurrentReport;

- (IBAction)culturalNothingToReport:(id)sender;

@end