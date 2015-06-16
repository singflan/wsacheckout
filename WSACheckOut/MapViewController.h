//
//  MapViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/6/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "MapSettingsViewController.h"

@interface MapViewController : UIViewController <AGSMapViewLayerDelegate, AGSLayerDelegate, AGSMapViewTouchDelegate, AGSCalloutDelegate, AGSFeatureLayerEditingDelegate, UIAlertViewDelegate, MapSettingsViewControllerDelegate>

@property (strong, nonatomic) IBOutlet AGSMapView *mapView;
@property (nonatomic,strong) IBOutlet UIStepper *levelStepper;

@property (strong, nonatomic) AGSTiledMapServiceLayer *networkTiledLayer;
@property (strong, nonatomic) AGSLocalTiledLayer *ngTiledLayer;
@property (strong, nonatomic) AGSLocalTiledLayer *landManagementTiledLayer;
@property (strong, nonatomic) AGSLocalTiledLayer *wsaTiledLayer;
@property (strong, nonatomic) AGSExportTileCacheTask *tileCacheTask;
@property (strong, nonatomic) NSString *tileCacheDir;
@property (strong, nonatomic) AGSEnvelope *utahEnvelope;
@property (strong, nonatomic) AGSCredential *credential;
@property (strong, nonatomic) NSNumber *levelOfDetails;
@property (strong, nonatomic) AGSGraphicsLayer *kopGraphicsLayer;
@property (strong, nonatomic) AGSFeatureLayer *featureLayer;
@property (strong, nonatomic) NSURL *mapService;
@property (strong, nonatomic) NSArray *areasArray;
@property (strong, nonatomic) NSUserDefaults *defaults;

- (void)zoomToUtahMap:(id)sender;
- (void)zoomToUser:(id)sender;
- (void)curlButtonAction:(id)sender;

@end
