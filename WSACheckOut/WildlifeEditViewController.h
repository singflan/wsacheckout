//
//  WildlifeEditViewController.h
//  WSAChecOut
//
//  Created by Timothy England on 1/16/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class WildLife;
@class DALinedTextView;

@interface WildlifeEditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gpsCoordinatesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wildlifeStatusImage;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIPickerView *wildlifeAnimal;
@property (weak, nonatomic) IBOutlet DALinedTextView *wildlifeDescription;
@property (weak, nonatomic) NSString *wildlifeAnimalSelected;
@property (strong, nonatomic) NSArray *animalList;

@property (strong, nonatomic) WildLife *theCurrentWildlife;

- (IBAction)saveWildlife:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
