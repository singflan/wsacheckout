//
//  Page4ViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 8/11/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "Page4ViewController.h"
#import "PlantsViewController.h"
#import "Report.h"

@interface Page4ViewController ()

@end

@implementation Page4ViewController

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
    
    CGRect plantlifevcRect = CGRectMake(40, 105, 700, 700);
    
    PlantsViewController *plantlifeViewController = [[PlantsViewController alloc] init];
    
    plantlifeViewController.theCurrentReport = self.theCurrentReport;
    
    UIStoryboard *plantlifeStoryboard = [UIStoryboard storyboardWithName:@"PlantlifeStoryboard" bundle:nil];
    
    plantlifeViewController = [plantlifeStoryboard instantiateInitialViewController];
    [self addChildViewController:plantlifeViewController];
    
    plantlifeViewController.view.frame = plantlifevcRect;
    [[self view] addSubview:plantlifeViewController.view];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    if ([self.theCurrentReport.reportStatus isEqualToString:@"finished"]) {
        
        self.view.backgroundColor = [UIColor lightGrayColor];
        self.plantlifeSwitch.enabled = NO;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = NO;
    }
    
    else {
        
        self.view.backgroundColor = [UIColor cloudsColor];
        self.plantlifeSwitch.enabled = YES;
        for (UIView *view in self.view.subviews)
            view.userInteractionEnabled = YES;
    }
    
    if ([self.theCurrentReport.plantStatus isEqualToString: @"Nothing To Report"]) {
        
        self.plantlifeSwitch.on = YES;
        
    }
    
    else {
        
        self.plantlifeSwitch.on = NO;
    }
}

- (IBAction)plantlifeNothingToReport:(id)sender {
    
    if (self.plantlifeSwitch.on == YES) {
        
        self.theCurrentReport.plantStatus = @"Nothing To Report";
    }
    
    else {
        
        if (self.theCurrentReport.sawPlantLife.count >= 1) {
            
            self.theCurrentReport.plantStatus = @"Plant(s) Reported";
        }
        
        else {
            
            self.theCurrentReport.plantStatus = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end