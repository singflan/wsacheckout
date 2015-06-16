//
//  MapViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/6/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "MapViewController.h"
#import "LoginController.h"
#import "WebMercatorUtil.h"
#import "GPSCoordinates.h"
#import "SVProgressHUD.h"
#import "ProgressHUD.h"
#import "MessageHelper.h"
#import "BackgroundHelper.h"

@interface MapViewController ()

@end

@implementation MapViewController

-(NSArray *)areasArray {
    
    if (!_areasArray) {
        _areasArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ListOfWSA" ofType:@"plist"]];
    }
    
    return _areasArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    // Set the client ID
    NSError *error;
    NSString* clientID = @"SgThuGF2HeHmSTNi";
    [AGSRuntimeEnvironment setClientID:clientID error:&error];
    if(error){
        // We had a problem using our client ID
        NSLog(@"Error using client ID : %@",[error localizedDescription]);
    }
    
    //Login Info
    NSString* username = @"macboyrules";
    NSString* password = @"iam2c00l";
    self.credential = [[AGSCredential alloc] initWithUser:username password:password];

    UINavigationBar *mapNavBar = [[UINavigationBar alloc] init];
    [mapNavBar setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    mapNavBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mapNavBar];
    
    // create the logout button
    UIButton* logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    [navItem setLeftBarButtonItem:logoutButtonItem];
    
    [mapNavBar setItems:@[navItem]];
    mapNavBar.topItem.title = @"WSA CheckOut";
    
    // Create the Basemap URL
    self.mapService = [NSURL URLWithString:@"http://tiledbasemaps.arcgis.com/arcgis/rest/services/NatGeo_World_Map/MapServer"];
    
    // set the delegates for the map view
    self.mapView.touchDelegate = self;
    self.mapView.layerDelegate = self;
    self.mapView.callout.delegate = self;
    
    self.mapView.callout.accessoryButtonHidden = YES;
    self.mapView.showMagnifierOnTapAndHold = YES;
    
    //create envelope to be used as default
    double xMin = [WebMercatorUtil toWebMercatorX:-114.071045];
    double yMin = [WebMercatorUtil toWebMercatorY:42.008489];
    double xMax = [WebMercatorUtil toWebMercatorX:-109.050293];
    double yMax = [WebMercatorUtil toWebMercatorY:36.993778];

//      Montana Code
//    double xMin = [WebMercatorUtil toWebMercatorX:-116.033333];
//    double yMin = [WebMercatorUtil toWebMercatorY:49.0];
//    double xMax = [WebMercatorUtil toWebMercatorX:-104.033333];
//    double yMax = [WebMercatorUtil toWebMercatorY:44.433333];
    
    
    self.utahEnvelope = [AGSEnvelope envelopeWithXmin:xMin
                                                 ymin:yMin
                                                 xmax:xMax
                                                 ymax:yMax
                                     spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
//    [self.defaults setValue:@"" forKey:@"tileCacheDir"];
    
    if ([[self.defaults stringForKey:@"tileCacheDir"] isEqualToString: @""] || [[self.defaults stringForKey:@"tileCacheDir"] isEqual: nil]) {
        
    }else{
        if (!self.ngTiledLayer) {
            
            self.tileCacheDir = [self.defaults stringForKey:@"tileCacheDir"];
            self.ngTiledLayer = [AGSLocalTiledLayer localTiledLayerWithPath:self.tileCacheDir];
        }
    }
    
    if ([[self.defaults valueForKey:@"CurrentMapView"] isEqual: nil]) {
        
        [self didSelectMapView:0];
        
    }else{
        
        [self didSelectMapView:[self.defaults integerForKey:@"CurrentMapView"]];
    }
    
    [self createMapLayers];
    [self createMapControls];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];

    if ([self.mapView loaded]) {
        
        [self.mapView.locationDisplay startDataSource];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    //turn off the location until it is needed when switching out of map view
    [super viewWillDisappear:NO];
    
    [self.mapView.locationDisplay stopDataSource];
}



#pragma mark - AGSMapViewLayerDelegate methods

-(void) mapViewDidLoad:(AGSMapView *)mapView {
    
    NSLog (@"MapView did load");
    [self.mapView.locationDisplay startDataSource];
    
}

- (void) layer:(AGSLayer*)layer didFailToLoadwithError:(NSError *)error {
    
    //Alert user of error
    [[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:Nil cancelButtonTitle:nil otherButtonTitles:nil, nil] show];
    
    NSLog(@"Error: %@",error);
}

- (void)layerDidLoad:(AGSLayer *)layer {
    
    if (layer == self.networkTiledLayer) {
        
        NSLog(@"Layer %@ added successfully", layer.name);
    }
}

#pragma mark - Cache Tiles

- (void)prepareDownloadTiles {
    
    // Init the tile cache task
    if ( self.tileCacheTask == nil) {
        
        self.tileCacheTask = [[AGSExportTileCacheTask alloc] initWithURL:self.mapService
                                                              credential:self.credential];
    }
    
    NSLog (@"%@", self.tileCacheTask.tiledServiceInfo);
    
    //Create an array for LODs
    NSArray *detailLevels = [NSArray arrayWithObjects:@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",nil];
    
    //Create an envelope to download
    double xMin = [WebMercatorUtil toWebMercatorX:-114.1];
    double yMin = [WebMercatorUtil toWebMercatorY:42.1];
    double xMax = [WebMercatorUtil toWebMercatorX:-109.0];
    double yMax = [WebMercatorUtil toWebMercatorY:36.9];
    
    AGSEnvelope *downloadEnvelope = [AGSEnvelope envelopeWithXmin:xMin
                                                 ymin:yMin
                                                 xmax:xMax
                                                 ymax:yMax
                                     spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    //Prepare params using levels and envelope
    AGSExportTileCacheParams *params = [[AGSExportTileCacheParams alloc] initWithLevelsOfDetail:detailLevels areaOfInterest:downloadEnvelope];
    
    //kick-off operation to estimate size
    [self.tileCacheTask estimateTileCacheSizeWithParameters:params status:^(AGSResumableTaskJobStatus status, NSDictionary *userInfo) {
        NSLog(@"%@, %@", AGSResumableTaskJobStatusAsString(status) ,userInfo);
    } completion:^(AGSExportTileCacheSizeEstimate *tileCacheSizeEstimate, NSError *error) {
        if ( error != nil) {
            
            //Report error to user
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [ProgressHUD dismiss];
        }else{
            
            //Display results (# of bytes and tiles), properly formatted, ofcourse
            NSNumberFormatter* tileCountFormatter = [[NSNumberFormatter alloc]init];
            [tileCountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [tileCountFormatter setMaximumFractionDigits:0];
            NSString* tileCountString = [tileCountFormatter stringFromNumber:[NSNumber numberWithInteger:tileCacheSizeEstimate.tileCount]];
            
            NSByteCountFormatter* byteCountFormatter = [[NSByteCountFormatter alloc]init];
            NSString* byteCountString = [byteCountFormatter stringFromByteCount:tileCacheSizeEstimate.fileSize];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:[[NSString alloc] initWithFormat:@"Estimate size:\n%@ bytes / %@ tiles", byteCountString, tileCountString] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download", nil];
            alert.tag = 1;
            [alert show];
            [ProgressHUD dismiss];
        }
        
    }];
    [ProgressHUD show:@"Estimating\n size" Interaction:NO];
    
}

- (void)downloadTiles {
    
    //Create an array for LODs
    NSArray *detailLevels = [NSArray arrayWithObjects:@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",nil];
    
    //Create an envelope to download
    double xMin = [WebMercatorUtil toWebMercatorX:-114.1];
    double yMin = [WebMercatorUtil toWebMercatorY:42.1];
    double xMax = [WebMercatorUtil toWebMercatorX:-109.0];
    double yMax = [WebMercatorUtil toWebMercatorY:36.9];
    
    AGSEnvelope *downloadEnvelope = [AGSEnvelope envelopeWithXmin:xMin
                                                             ymin:yMin
                                                             xmax:xMax
                                                             ymax:yMax
                                                 spatialReference:[AGSSpatialReference webMercatorSpatialReference]];
    
    //Prepare params using levels and envelope
    AGSExportTileCacheParams *params = [[AGSExportTileCacheParams alloc] initWithLevelsOfDetail:detailLevels areaOfInterest:downloadEnvelope];
    
    //Kick-off operation
    [self.tileCacheTask exportTileCacheWithParameters:params downloadFolderPath:nil useExisting:YES status:^(AGSResumableTaskJobStatus status, NSDictionary *userInfo) {
        
        //Print the job status
        NSLog(@"%@, %@", AGSResumableTaskJobStatusAsString(status) ,userInfo);
        NSArray *allMessages =  [userInfo objectForKey:@"messages"];
        
        //Display download progress if we are fetching result
        if (status == AGSResumableTaskJobStatusFetchingResult) {
            NSNumber* totalBytesDownloaded = userInfo[@"AGSDownloadProgressTotalBytesDownloaded"];
            NSNumber* totalBytesExpected = userInfo[@"AGSDownloadProgressTotalBytesExpected"];
            if(totalBytesDownloaded!=nil && totalBytesExpected!=nil){
                double dPercentage = (double)([totalBytesDownloaded doubleValue]/[totalBytesExpected doubleValue]);
                [SVProgressHUD showProgress:dPercentage status:@"Downloading" maskType:SVProgressHUDMaskTypeGradient];
            }
        }else if ( allMessages.count) {
            
            //Else, display latest progress message provided by the service
            [SVProgressHUD showWithStatus:[MessageHelper extractMostRecentMessage:allMessages] maskType:SVProgressHUDMaskTypeGradient];
        }
        
        
    } completion:^(AGSLocalTiledLayer *localTiledLayer, NSError *error) {
        [SVProgressHUD dismiss];
        if (error){
            
            //alert the user
            [[[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else{
            
            //clear out the map, and add the downloaded tile cache to the map
            [self.mapView reset];
            self.ngTiledLayer = localTiledLayer;
            [self.defaults setValue:self.ngTiledLayer.cachePath forKey:@"tileCacheDir"];
            [self.mapView addMapLayer:self.ngTiledLayer withName:@"Basemap Tiled Layer"];
            
            [self createMapLayers];
            [self createMapControls];
            
            //Tell the user we're done
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download complete" message:@"The tile cache has been added to the map." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [BackgroundHelper postLocalNotificationIfAppNotActive:@"Tile cache downloaded."];
        }
    }];
    [SVProgressHUD showWithStatus:@"Preparing\n to download" maskType:SVProgressHUDMaskTypeGradient];
    

}

#pragma mark - Create Map Layers

- (void)createMapLayers {
    
    // Add the Land Admin Layer
    if (self.landManagementTiledLayer == nil) {
        self.landManagementTiledLayer = [ AGSLocalTiledLayer localTiledLayerWithName:@"ACE_WSA_LandAdmin"];
        [self.mapView insertMapLayer:self.landManagementTiledLayer withName:@"Admin Layer" atIndex:1];
        self.landManagementTiledLayer.visible = NO;
    }
    
    //Add the WSA Layer
    if (self.wsaTiledLayer == nil) {
        
        self.wsaTiledLayer = [AGSLocalTiledLayer localTiledLayerWithName:@"ACE_WSA"];
        [self.mapView insertMapLayer:self.wsaTiledLayer withName:@"WSA Service Layer" atIndex:2];
    }

    //KOP Layer
    if ( self.kopGraphicsLayer == nil) {
        
        self.kopGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
        [self populateKOPs];
        [self.mapView insertMapLayer:self.kopGraphicsLayer withName:@"KOP Graphics Layer" atIndex:3];
    }
}

#pragma mark - Create Map Controls

- (void)createMapControls {
    
    CGRect esriGraphicRect = CGRectMake (20, 920, 56, 32);
    CGRect blmGraphicRect = CGRectMake (675, 85, 72, 66);
    CGRect settingsButtonRect = CGRectMake (708, 926, 28, 28);
    CGRect zoomButtonRect = CGRectMake(660, 923, 32, 32);
    CGRect compassButtonRect = CGRectMake(620, 928, 22, 22);
    CGRect naviBackRect = CGRectMake(614, 920, 130, 40);
    
    //Create overlay buttons
    
    NSString *esriLogoImage = @"ArcGIS.bundle/esri.png";
    UIImageView *esriLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:esriLogoImage]];
    esriLogo.frame = esriGraphicRect;
    
    NSString *blmLogoImage = @"blm_logo";
    UIImageView *blmLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:blmLogoImage]];
    blmLogo.layer.opacity = 0.7;
    blmLogo.frame = blmGraphicRect;
    
    [self.view addSubview:esriLogo];
    [self.view addSubview:blmLogo];
    
    UIImageView *naviBack = [[UIImageView alloc] initWithFrame:naviBackRect];
    naviBack.backgroundColor = [UIColor cloudsColor];
    naviBack.alpha = 0.7;
    naviBack.layer.cornerRadius = 3.0f;
    naviBack.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    naviBack.layer.shadowOffset = CGSizeMake(2, 2);
    naviBack.layer.shadowOpacity = 0.7;
    naviBack.layer.shadowRadius = 2.0f;
    
    [self.view addSubview:naviBack];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = settingsButtonRect;
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"Edit Map"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(curlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingsButton];
    
    UIButton *zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zoomButton.frame = zoomButtonRect;
    [zoomButton setBackgroundImage:[UIImage imageNamed:@"Expand"] forState:UIControlStateNormal];
    zoomButton.tintColor = [UIColor whiteColor];
    [zoomButton addTarget:self action:@selector(zoomToUtahMap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:zoomButton];
    
    UIButton *compassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    compassButton.frame = compassButtonRect;
    [compassButton setBackgroundImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    compassButton.tintColor = [UIColor whiteColor];
    [compassButton addTarget:self action:@selector(zoomToUser:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:compassButton];
}

#pragma mark - Curl Page methods

- (void)curlButtonAction:(id)sender
{
    
    MapSettingsViewController *settingsViewController = [[MapSettingsViewController alloc] init];
    settingsViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    settingsViewController.delegate = self;
    
    [self presentViewController:settingsViewController animated:YES completion:nil];
    
}

#pragma mark - Populate the KOPs on the map

- (void)populateKOPs {
    
    //create a marker symbol to be used by our Graphic
    AGSPictureMarkerSymbol *myMarkerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"Map Marker"] ;
    myMarkerSymbol.color = [UIColor midnightBlueColor];
    
    for (int i = 0; i < [self.areasArray count]; i++) {
        
        double latNumber = [[[self.areasArray objectAtIndex:i] valueForKey:@"Lat"] doubleValue];
        double longNumber = [[[self.areasArray objectAtIndex:i] valueForKey:@"Long"] doubleValue];
        NSString *kopName = [[self.areasArray objectAtIndex:i] valueForKey:@"KOP"];
        NSString *kopLatNumber = [[[self.areasArray objectAtIndex:i] valueForKey:@"Lat"] stringValue];
        NSString *kopLongNumber = [[[self.areasArray objectAtIndex:i] valueForKey:@"Long"] stringValue];
        double newLatNumber = [WebMercatorUtil toWebMercatorY:latNumber];
        double newLongNumber = [WebMercatorUtil toWebMercatorX:longNumber];
        
        //Create an AGSPoint (which inherits from AGSGeometry) that
        //defines where the Graphic will be drawn
        AGSPoint* myMarkerPoint = [AGSPoint pointWithX:newLongNumber y:newLatNumber spatialReference:self.mapView.spatialReference];
        
        NSMutableDictionary *graphicsAttributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   kopLatNumber, @"Lat",
                                                   kopLongNumber, @"Long",
                                                   kopName, @"KOP",
                                                   nil];
        
        //Create the Graphic, using the symbol and
        //geometry created earlier
        AGSGraphic* myGraphic = [AGSGraphic graphicWithGeometry:myMarkerPoint
                                                         symbol:myMarkerSymbol
                                                     attributes:graphicsAttributes];
        
        //Add the graphic to the Graphics layer
        [self.kopGraphicsLayer addGraphic:myGraphic];
        
    }
    
}

#pragma mark - Delegate Methods

- (void)zoomToUtahMap:(id)sender {
    
    [self.mapView.callout dismiss];
    
    //Zoom To Envelope
    
    //call method to set extent, pass in envelope
    [self.mapView zoomToEnvelope:self.utahEnvelope animated:YES];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeOff;
    
}

- (void)zoomToUser:(id)sender {
    
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    self.mapView.locationDisplay.navigationPointHeightFactor  = 0.5;
    [self.mapView zoomToScale:1.0 animated:YES];
}

-(void) didSelectMapView:(NSInteger)selection {
    
    [self.defaults setInteger:selection forKey:@"CurrentMapView"];
    
    switch (selection) {
            
        case 0: //Standard
            
            self.mapService = [NSURL URLWithString:@"http://tiledbasemaps.arcgis.com/arcgis/rest/services/NatGeo_World_Map/MapServer"];
            break;
            
        case 1: //TOPO
            
            self.mapService = [NSURL URLWithString:@"http://tiledbasemaps.arcgis.com/arcgis/rest/services/USA_Topo_Maps/MapServer"];
            break;
            
        case 2: //Satalite
            self.mapService = [NSURL URLWithString:@"http://tiledbasemaps.arcgis.com/arcgis/rest/services/World_Imagery/MapServer"];
            break;
            
        default:
            break;
    }
    
    //Remove existing basemap layer
    [self.mapView removeMapLayerWithName:@"Basemap Tiled Layer"];
    
    //Replace the basemap layer
    
    if (selection > 0) {
        
        self.networkTiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:self.mapService
                                                                           credential:self.credential];
        self.networkTiledLayer.name = @"Basemap Tiled Layer";
        [self.mapView insertMapLayer:self.networkTiledLayer withName:@"Basemap Tiled Layer" atIndex:0];
        
    } else {
        if (self.ngTiledLayer == nil) {
            
            self.networkTiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:self.mapService
                                                                               credential:self.credential];
            self.networkTiledLayer.name = @"Basemap Tiled Layer";
            [self.mapView insertMapLayer:self.networkTiledLayer withName:@"Basemap Tiled Layer" atIndex:0];
        } else {
            
            [self.mapView insertMapLayer:self.ngTiledLayer withName:@"Basemap Tiled Layer" atIndex:0];
        }
    }
    
    [self.mapView zoomToEnvelope:self.utahEnvelope animated:YES];
}

-(void) didSelectReportView:(NSInteger)selection {
    
    [self.defaults setInteger:selection forKey: @"CurrentMapReportView"];
    
}

- (void) didSelectDeleteCache {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *filePath = [self.defaults stringForKey:@"tileCacheDir"];
    [fileManager removeItemAtPath:filePath error:&error];
    if (error){
        NSLog(@"%@", error);
        [ProgressHUD showError:error.localizedFailureReason];
    } else {
        [ProgressHUD showSuccess:@"The cache file\nwas successfully deleted."];
        [self.defaults removeObjectForKey:@"tileCacheDir"];
        [self.mapView reset];
        self.ngTiledLayer = nil;
        [self didSelectMapView:0];
        [self createMapLayers];
        [self createMapControls];
    }
}

- (void) didSelectDownloadCache {
    
    [self prepareDownloadTiles];
}

#pragma mark - AGSCallout Delegate

-(BOOL)callout:(AGSCallout*)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable>*)layer mapPoint:(AGSPoint*)mapPoint {
	
    //Specify the callout's contents
	self.mapView.callout.title = (NSString*)[feature attributeForKey:@"KOP"];
    
    NSNumber *lat = [feature attributeForKey:@"Lat"];
    NSNumber *lon = [feature attributeForKey:@"Long"];
	self.mapView.callout.detail = [GPSCoordinates WithLatitude:[lat doubleValue] WithLongitude:[lon doubleValue]];
    self.mapView.callout.accessoryButtonType = UIButtonTypeDetailDisclosure;
    self.mapView.callout.accessoryButtonHidden = NO;
    
	return YES;
}

-(void) didClickAccessoryButtonForCallout:(AGSCallout *)callout {
    
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeOff;
    [self.mapView zoomToScale:1.0 withCenterPoint:callout.mapLocation animated:YES];
}

#pragma mark - UIAlertView Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0)
        {
            [self createMapControls];
            [self createMapLayers];
            [self.mapView.locationDisplay startDataSource];
        }
        
        else if(buttonIndex == 1)
        {
            [self downloadTiles];
        }
    }
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
