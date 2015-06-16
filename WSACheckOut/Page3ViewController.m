//
//  Page3ViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 8/11/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "Page3ViewController.h"
#import "WildlifeViewController.h"
#import "Report.h"

@interface Page3ViewController ()

@end

@implementation Page3ViewController

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
    
    self.page3Title.font = [UIFont fontWithName:@"Avenir-Black" size:22.0f];
    
    CGRect wildlifevcRect = CGRectMake(40, 105, 700, 700);
    
    WildlifeViewController *wildlifeViewController = [[WildlifeViewController alloc] init];

    wildlifeViewController.theCurrentReport = self.theCurrentReport;
    
    UIStoryboard *wildlifeStoryboard = [UIStoryboard storyboardWithName:@"WildlifeStoryboard" bundle:nil];
    wildlifeViewController = [wildlifeStoryboard instantiateInitialViewController];
    
    [self addChildViewController:wildlifeViewController];
    wildlifeViewController.view.frame = wildlifevcRect;
    [[self view] addSubview:wildlifeViewController.view];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([self.theCurrentReport.reportStatus isEqualToString:@"finished"]) {
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        self.wildlifeSwitch.enabled = NO;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = NO;
    }
    
    else {
        
        self.view.backgroundColor = [UIColor cloudsColor];
        self.wildlifeSwitch.enabled = YES;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = YES;
    }
    
    if ([self.theCurrentReport.wildlifeStatus isEqualToString: @"Nothing To Report"]) {
        
        self.wildlifeSwitch.on = YES;
        
    }
    
    else {
        
        self.wildlifeSwitch.on = NO;
    }

}

- (IBAction)wildlifeNothingToReport:(id)sender {
    
    if (self.wildlifeSwitch.on == YES) {
        
        self.theCurrentReport.wildlifeStatus = @"Nothing To Report";
    }
    
    else {
        
        if (self.theCurrentReport.sawWildLife.count >= 1) {
            
            self.theCurrentReport.wildlifeStatus = @"Wildlife Reported";
        }
        
        else {
            
            self.theCurrentReport.wildlifeStatus = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
