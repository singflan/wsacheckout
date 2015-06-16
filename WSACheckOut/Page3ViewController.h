//
//  Page3ViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 8/11/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;

@interface Page3ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *page3Title;

@property (strong, nonatomic) IBOutlet UISwitch *wildlifeSwitch;

@property (strong, nonatomic) Report *theCurrentReport;

- (IBAction)wildlifeNothingToReport:(id)sender;

@end
