//
//  Page2ViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 8/11/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "Page2ViewController.h"
#import "DisturbViewController.h"
#import "Report.h"

@interface Page2ViewController ()

@end

@implementation Page2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cloudsColor];
    
    self.page2Title.font = [UIFont fontWithName:@"Avenir-Black" size:22.0f];
    
    CGRect disturbvcRect = CGRectMake (40, 105, 700, 700);
    
    DisturbViewController *disturbViewController = [[DisturbViewController alloc] init];
    
    disturbViewController.theCurrentReport = self.theCurrentReport;
    
    UIStoryboard *disturbStoryboard = [UIStoryboard storyboardWithName:@"DisturbStoryboard" bundle:nil];
    
    disturbViewController = [disturbStoryboard instantiateInitialViewController];
    
    [self addChildViewController:disturbViewController];
    
    disturbViewController.view.frame = disturbvcRect;
    
    [[self view] addSubview:disturbViewController.view];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    
    if ([self.theCurrentReport.reportStatus isEqualToString:@"finished"]) {

        self.view.backgroundColor = [UIColor lightGrayColor];
        self.disturbSwitch.enabled = NO;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = NO;
    }
    
    else {
        
        self.view.backgroundColor = [UIColor cloudsColor];
        self.disturbSwitch.enabled = YES;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = YES;
    }
    
    if ([self.theCurrentReport.disturbStatus isEqualToString: @"Nothing To Report"]) {
        
        self.disturbSwitch.on = YES;
        
    }
    
    else {
        
        self.disturbSwitch.on = NO;
    }
}

- (IBAction)disturbNothingToReport:(id)sender {
    
    if (self.disturbSwitch.on == YES) {
        
        self.theCurrentReport.disturbStatus = @"Nothing To Report";
    }
    
    else {
        
        if (self.theCurrentReport.sawDisturbances.count >= 1) {
            
            self.theCurrentReport.disturbStatus = @"Disturbance(s) Reported";
        }
        
        else {
            
            self.theCurrentReport.disturbStatus = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
