//
//  DisturbEditViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 1/14/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class Disturbances;
@class DALinedTextView;

@interface DisturbEditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *gpsCoordinatesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *disturbStatusImage;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) IBOutlet UITextField *disturbDescription;
@property (strong, nonatomic) IBOutlet DALinedTextView *disturbImpact;

@property (strong, nonatomic) NSString *selectedCategory;
@property (strong, nonatomic) Disturbances *theCurrentDisturbance;

-(void)backButton:(id)sender;
- (IBAction)saveDisturbance:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)selectCategoryList:(id)sender;

@end
