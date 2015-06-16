//
//  Page2ViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 8/11/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;

@interface Page2ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *page2Title;

@property (strong, nonatomic) IBOutlet UISwitch *disturbSwitch;

@property (strong, nonatomic) Report *theCurrentReport;

- (IBAction)disturbNothingToReport:(id)sender;

@end
