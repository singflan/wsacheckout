//
//  MainViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "MainViewController.h"
#import "LoginController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus) name:FXReachabilityStatusDidChangeNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"UseMagneticNorth"];
    
    if (![[defaults stringForKey:@"LoginStatus"]  isEqual: @"YES"]) {
        
        UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
        LoginController* loginViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"Login"];
        
        [self presentViewController:loginViewController animated:YES completion:nil];
        loginViewController.view.superview.center = CGPointMake(roundf(self.view.center.x), roundf(self.view.center.y));
    }
    
    [super viewDidAppear:YES];
}

- (void)updateStatus {
    
    NSString *statusText = nil;
    
    {
        switch ([FXReachability sharedInstance].status)
        {
            case FXReachabilityStatusUnknown:
            {
                statusText = @"Status Unknown";
            }
            case FXReachabilityStatusNotReachable:
            {
                statusText = @"Not reachable";
            }
            case FXReachabilityStatusReachableViaWWAN:
            {
                statusText = @"Reachable via WWAN";
            }
            case FXReachabilityStatusReachableViaWiFi:
            {
                statusText = @"Reachable via WiFi";
            }
        }
    }
    
    NSLog(@"%@", statusText);
    
}

- (void)didReceiveMemoryWarning
{
    
#ifdef DEBUG
	NSLog(@"%s", __FUNCTION__);
#endif
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
