//
//  PhotoViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 4/22/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Report;
@class KOP;
@class Disturbances;
@class WildLife;
@class PlantLife;
@class Cultural;

@interface PhotoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *photoView;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@property (strong, nonatomic) KOP *kopPhotoReference;
@property (strong, nonatomic) Disturbances *disturbancePhotoReference;
@property (strong, nonatomic) WildLife *wildlifePhotoReference;
@property (strong, nonatomic) PlantLife *plantlifePhotoReference;
@property (strong, nonatomic) Cultural *culturalPhotoReference;

@property (strong, nonatomic) NSData *photoData;
@property (strong, nonatomic) NSString *reportType;
@property (strong, nonatomic) NSString *photoEntity;

- (IBAction)cancelPhotoView:(id)sender;
- (IBAction)deletePhoto:(id)sender;

@end
