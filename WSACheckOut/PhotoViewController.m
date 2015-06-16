//
//  PhotoViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 4/22/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "PhotoViewController.h"
#import "Report.h"
#import "KOP.h"
#import "Disturbances.h"
#import "WildLife.h"
#import "PlantLife.h"
#import "Cultural.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    
    self.photoView.image = [UIImage imageWithData:self.photoData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPhotoView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deletePhoto:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete the photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"DELETE",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if ([self.reportType isEqualToString:@"KOP"]) {
            
            [self.kopPhotoReference setNilValueForKey:self.photoEntity];
            [self.kopPhotoReference save];
        }
        
        else if ([self.reportType isEqualToString:@"Disturbances"]) {
            
            [self.disturbancePhotoReference setNilValueForKey:self.photoEntity];
            [self.disturbancePhotoReference save];
        }
        
        else if ([self.reportType isEqualToString:@"WildLife"]) {
            
            [self.wildlifePhotoReference setNilValueForKey:self.photoEntity];
            [self.wildlifePhotoReference save];
        }
        
        else if ([self.reportType isEqualToString:@"PlantLife"]) {
            
            [self.plantlifePhotoReference setNilValueForKey:self.photoEntity];
            [self.plantlifePhotoReference save];
        }
        
        else if ([self.reportType isEqualToString:@"Cultural"]) {
            
            [self.culturalPhotoReference setNilValueForKey:self.photoEntity];
            [self.culturalPhotoReference save];
        }
        
        else {
            
            NSLog(@"Couldn't recognize the report type.  The photo wasn't deleted");
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UIUpdateThumbnails" object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.parentViewController viewWillAppear:NO];
    }
}


@end
