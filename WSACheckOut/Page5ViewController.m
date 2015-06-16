//
//  Page5ViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/17/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "Page5ViewController.h"
#import "CulturalViewController.h"
#import "Report.h"

@interface Page5ViewController ()

@end

@implementation Page5ViewController

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
    
    self.page5Title.font = [UIFont fontWithName:@"Avenir-Black" size:22.0f];
    
    CGRect culturalvcRect = CGRectMake (40, 105, 700, 700);
    
    CulturalViewController *culturalViewController = [[CulturalViewController alloc] init];
    
    culturalViewController.theCurrentReport = self.theCurrentReport;
    
    UIStoryboard *culturalStoryboard = [UIStoryboard storyboardWithName:@"CulturalStoryboard" bundle:nil];
    
    culturalViewController = [culturalStoryboard instantiateInitialViewController];
    [self addChildViewController:culturalViewController];
    
    culturalViewController.view.frame = culturalvcRect;
    [[self view] addSubview:culturalViewController.view];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    if ([self.theCurrentReport.reportStatus isEqualToString:@"finished"]) {
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        self.culturalSwitch.enabled = NO;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = NO;
    }
    
    else {
        
        self.view.backgroundColor = [UIColor cloudsColor];
        self.culturalSwitch.enabled = YES;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = YES;
    }
    
    if ([self.theCurrentReport.culturalStatus isEqualToString: @"Nothing To Report"]) {
        
        self.culturalSwitch.on = YES;
        
    }
    
    else {
        
        self.culturalSwitch.on = NO;
    }
}

- (IBAction)culturalNothingToReport:(id)sender {
    
    if (self.culturalSwitch.on == YES) {
        
        self.theCurrentReport.culturalStatus = @"Nothing To Report";
    }
    
    else {
        
        if (self.theCurrentReport.sawCultural.count >= 1) {
            
            self.theCurrentReport.culturalStatus = @"Disturbance(s) Reported";
        }
        
        else {
            
            self.theCurrentReport.culturalStatus = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
