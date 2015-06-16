//
//  MapSettingsViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 9/2/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapSettingsViewControllerDelegate <NSObject>

-(void) didSelectMapView:(NSInteger)selection;
-(void) didSelectReportView:(NSInteger)selection;
-(void) didSelectDeleteCache;
-(void) didSelectDownloadCache;

@end

@interface MapSettingsViewController : UIViewController {
    
    id <MapSettingsViewControllerDelegate> delegate;

}

@property (strong, nonatomic) id <MapSettingsViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISegmentedControl *showReportsSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapViewSegmentedControl;
@property (strong, nonatomic) NSUserDefaults *defaults;

- (IBAction)mapViewSelection:(id)sender;
- (IBAction)showReports:(id)sender;
- (IBAction)deleteMapCache:(id)sender;
- (IBAction)downloadMapCache:(id)sender;

@end
