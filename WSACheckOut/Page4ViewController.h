//
//  Page4ViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 8/11/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;

@interface Page4ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *plantlifeSwitch;

@property (strong, nonatomic) Report *theCurrentReport;

- (IBAction)plantlifeNothingToReport:(id)sender;

@end
