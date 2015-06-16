//
//  KOPEditViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 9/4/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "KOPEditViewController.h"
#import "CompassView.h"
#import "KOP.h"
#import "UIImage+Thumbnail.h"
#import "DALinedTextView.h"
#import "UIView+FormScroll.h"
#import "GPSCoordinates.h"
#import "PhotoViewController.h"
#import "ProgressHUD.h"

@interface KOPEditViewController ()

@end

@implementation KOPEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeOrientation)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateThumbnails:)
                                                 name:@"UIUpdateThumbnails" object:nil];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.overlayView = [[CompassView alloc] initWithFrame:CGRectMake(50, 50, 80, 80)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopSwipe" object:self];
    
    if (self.theCurrentKOP.kopDescription == nil) {
        self.kopDescription.textColor = [UIColor lightGrayColor];
        self.kopDescription.text = @"Enter your KOP notes here.";
    }
    else {
        
        self.kopDescription.text = self.theCurrentKOP.kopDescription;
    }
    
    double kopLat = [self.theCurrentKOP.kopGPSLatitude doubleValue];
    double kopLong = [self.theCurrentKOP.kopGPSLongitude doubleValue];
    self.kopGPSCoordinatesLabel.text = [GPSCoordinates WithLatitude:kopLat WithLongitude:kopLong];
    
    //Get the user's location

	[self.locationManager startUpdatingLocation];
    
	if (!self.locationManager.location) {
		return;
	}
    
    double lat = self.locationManager.location.coordinate.latitude;
    double lon = self.locationManager.location.coordinate.longitude;
    
    self.gpsCoordinatesLabel.font = [UIFont fontWithName:@"Avenir" size:12.0f];
    self.gpsCoordinatesLabel.text = [GPSCoordinates WithLatitude:lat WithLongitude:lon];
    
    //give a green arrow if all the pictures and info is filled
    
    if ([self.theCurrentKOP.kopStatus isEqualToString:@"Complete"]) {
        
        self.kopStatusImage.image = [UIImage imageNamed:@"check-green"];
    }
    
    [self updateThumbnails:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSwipe" object:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - LocationManager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    double lat = self.locationManager.location.coordinate.latitude;
    double lon = self.locationManager.location.coordinate.longitude;
    
    self.gpsCoordinatesLabel.font = [UIFont fontWithName:@"Avenir" size:12.0f];
    self.gpsCoordinatesLabel.text = [GPSCoordinates WithLatitude:lat WithLongitude:lon];
    
}

#pragma mark DALinedTextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(DALinedTextView *)textView
{
    if ([textView.text isEqualToString:@"Enter your KOP notes here."]) {
        self.kopDescription.text = @"";
    }
    self.kopDescription.textColor = [UIColor blackColor];
    [self.view scrollToView:textView];
    return YES;
}

-(void)textViewDidEndEditing:(DALinedTextView *)textView
{
    
    if (self.kopDescription.text.length == 0) {
        
        self.kopDescription.textColor = [UIColor lightGrayColor];
        self.kopDescription.text = @"Enter your KOP notes here.";
        [self.kopDescription resignFirstResponder];
    }
    [self.view scrollToY:0];
    [textView resignFirstResponder];
}

#pragma mark - Camera Methods

- (IBAction)takeNorthPhoto:(id)sender
{
    
    
    if (self.theCurrentKOP.kopPhotoN == nil) {
    [self.locationManager stopUpdatingLocation];
    [self takePhoto:sender];
    self.currentKOPPhotoDirection = @"kopPhotoN";
    }
    
    else {
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        
        photoViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        photoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [photoViewController setKopPhotoReference:self.theCurrentKOP];
        [photoViewController setPhotoData:self.theCurrentKOP.kopPhotoN];
        [photoViewController setReportType:@"KOP"];
        [photoViewController setPhotoEntity:@"kopPhotoN"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
        
    }
}

- (IBAction)takeEastPhoto:(id)sender
{
    
    if (self.theCurrentKOP.kopPhotoE ==nil) {
    [self.locationManager stopUpdatingLocation];
    [self takePhoto:sender];
    self.currentKOPPhotoDirection = @"kopPhotoE";
    }
    
    else {
     
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        
        photoViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        photoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [photoViewController setKopPhotoReference:self.theCurrentKOP];
        [photoViewController setPhotoData:self.theCurrentKOP.kopPhotoE];
        [photoViewController setReportType:@"KOP"];
        [photoViewController setPhotoEntity:@"kopPhotoE"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
    }
}

- (IBAction)takeSouthPhoto:(id)sender
{
    
    if (self.theCurrentKOP.kopPhotoS ==nil ) {
    [self.locationManager stopUpdatingLocation];
    [self takePhoto:sender];
    self.currentKOPPhotoDirection = @"kopPhotoS";
    }
    
    else {
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        
        photoViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        photoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [photoViewController setKopPhotoReference:self.theCurrentKOP];
        [photoViewController setPhotoData:self.theCurrentKOP.kopPhotoS];
        [photoViewController setReportType:@"KOP"];
        [photoViewController setPhotoEntity:@"kopPhotoS"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
    }
}

- (IBAction)takeWestPhoto:(id)sender
{
    
    if (self.theCurrentKOP.kopPhotoW == nil) {
    [self.locationManager stopUpdatingLocation];
    [self takePhoto:sender];
    self.currentKOPPhotoDirection = @"kopPhotoW";
    }
    
    else {
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        
        photoViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        photoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [photoViewController setKopPhotoReference:self.theCurrentKOP];
        [photoViewController setPhotoData:self.theCurrentKOP.kopPhotoW];
        [photoViewController setReportType:@"KOP"];
        [photoViewController setPhotoEntity:@"kopPhotoW"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
    }
}

- (void)takePhoto:(id)sender
{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePickerController setShowsCameraControls:YES];
        [imagePickerController setEditing:NO];
        [imagePickerController setNavigationBarHidden:YES];
        [imagePickerController setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CompassStartUpdating" object:self];
        imagePickerController.cameraOverlayView = self.overlayView;
        
        self.imagePickerController = imagePickerController;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }
    
    else {
        
    }
    
}

- (void) didChangeOrientation
{
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        
        self.overlayView.hidden = TRUE;
    }
    
    else {
        
        self.overlayView.hidden = FALSE;
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [ProgressHUD show:@"Saving Picture . . ."];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CompassStopUpdating" object:self];

    //Saving the image hangs up the UI.  GCD to offload to another thread.
    
    dispatch_queue_t imageSaveQueue = dispatch_queue_create("Image Save Queue",NULL);
    
    dispatch_async(imageSaveQueue, ^{
        
        UIImage *capturedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(capturedImage, 1.0);
        [self.theCurrentKOP setValue:imageData forKey:self.currentKOPPhotoDirection];
        [self.theCurrentKOP save];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ProgressHUD showSuccess:@"Picture saved."];
        });
    });
    
    [self updateThumbnails:self];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateThumbnails:self];
}

#pragma mark - Save Method

- (IBAction)saveKOPChanges:(id)sender
{
    
    self.theCurrentKOP.kopDescription = self.kopDescription.text;
    self.theCurrentKOP.kopDateTime = [NSDate date];
    
    if (self.theCurrentKOP.kopDescription !=nil && self.theCurrentKOP.kopName !=nil && self.theCurrentKOP.kopPhotoE !=nil && self.theCurrentKOP.kopPhotoN !=nil && self.theCurrentKOP.kopPhotoW !=nil && self.theCurrentKOP.kopPhotoW !=nil) {
        
        self.theCurrentKOP.kopStatus = @"Complete";
    }
    
    else {
        
        self.theCurrentKOP.kopStatus = @"Incomplete";
    }
    
    [self.theCurrentKOP save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Update Thumbnails Method

- (void)updateThumbnails:(id)sender {
    
    UIImage *defaultThumbnail = [UIImage imageNamed:@"Picture.png"];
    
    //replace generic pictures with previews if there is data
    
    if (self.theCurrentKOP.kopPhotoN != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentKOP.kopPhotoN];
        
        UIImage *thumbnail = [UIImage imageWithImage:picture scaledToSize:CGSizeMake(120, 86)];
        
        [self.northPhotoButton setImage:thumbnail forState:UIControlStateNormal];
        
    }
    
    else {
        
        [self.northPhotoButton setImage:defaultThumbnail forState:UIControlStateNormal];
    }
    
    if (self.theCurrentKOP.kopPhotoE != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentKOP.kopPhotoE];
        
        UIImage *thumbnail = [UIImage imageWithImage:picture scaledToSize:CGSizeMake(120, 86)];
        
        [self.eastPhotoButton setImage:thumbnail forState:UIControlStateNormal];
        
    }
    
    else {
        
        [self.eastPhotoButton setImage:defaultThumbnail forState:UIControlStateNormal];
    }
    
    if (self.theCurrentKOP.kopPhotoS != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentKOP.kopPhotoS];
        
        UIImage *thumbnail = [UIImage imageWithImage:picture scaledToSize:CGSizeMake(120, 86)];
        
        [self.southPhotoButton setImage:thumbnail forState:UIControlStateNormal];
        
    }
    
    else {
        
        [self.southPhotoButton setImage:defaultThumbnail forState:UIControlStateNormal];
    }
    
    if (self.theCurrentKOP.kopPhotoW != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentKOP.kopPhotoW];
        
        UIImage *thumbnail = [UIImage imageWithImage:picture scaledToSize:CGSizeMake(120, 86)];
        
        [self.westPhotoButton setImage:thumbnail forState:UIControlStateNormal];
        
    }
    
    else {
        
        [self.westPhotoButton setImage:defaultThumbnail forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIUpdateThumbnails" object:nil];
}

@end
