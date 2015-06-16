//
//  PlantsEditViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/28/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlantLife;
@class DALinedTextView;

@interface PlantsEditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gpsCoordinatesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *plantlifeStatusImage;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIPickerView *plantlifePlants;
@property (weak, nonatomic) IBOutlet DALinedTextView *plantlifeDescription;

@property (strong, nonatomic) NSString *plantlifePlantSelected;
@property (strong, nonatomic) NSArray *plantList;

@property (strong, nonatomic) PlantLife *theCurrentPlantlife;

- (IBAction)savePlantlife:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
