//
//  KOPEditViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 9/4/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class CompassView;
@class Report;
@class KOP;
@class DALinedTextView;

@interface KOPEditViewController : UIViewController <CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *gpsCoordinatesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *kopStatusImage;
@property (strong, nonatomic) IBOutlet UIButton *northPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *eastPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *southPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *westPhotoButton;
@property (strong, nonatomic) IBOutlet DALinedTextView *kopDescription;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *kopGPSCoordinatesLabel;
@property (strong, nonatomic) NSString *transferedKOPGPSCoordinates;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) CompassView *overlayView;
@property (strong, nonatomic) Report *theCurrentReport;
@property (strong, nonatomic) KOP *theCurrentKOP;
@property (strong, nonatomic) NSString *currentKOPPhotoDirection;

- (IBAction)saveKOPChanges:(id)sender;
- (IBAction)takeNorthPhoto:(id)sender;
- (IBAction)takeEastPhoto:(id)sender;
- (IBAction)takeSouthPhoto:(id)sender;
- (IBAction)takeWestPhoto:(id)sender;
- (void)takePhoto:(id)sender;
- (void)updateThumbnails:(id)sender;

@end
