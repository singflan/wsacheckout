//
//  CulturalEditViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 4/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class Cultural;
@class DALinedTextView;

@interface CulturalEditViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *gpsCoordinatesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *culturalStatusImage;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UITextField *culturalDescription;
@property (weak, nonatomic) IBOutlet DALinedTextView *culturalObserved;

@property (strong, nonatomic) Cultural *theCurrentCultural;

-(void)backButton:(id)sender;
- (IBAction)saveCultural:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end
