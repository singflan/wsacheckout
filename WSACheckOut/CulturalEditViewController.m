//
//  CulturalEditViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 4/18/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "CulturalEditViewController.h"
#import "PhotoViewController.h"
#import "Cultural.h"
#import "DALinedTextView.h"
#import "UIImage+Thumbnail.h"
#import "GPSCoordinates.h"
#import "ProgressHUD.h"

@interface CulturalEditViewController ()

@end

@implementation CulturalEditViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopSwipe" object:self];
    
    double kopLat = [self.theCurrentCultural.culturalGPSLatitude doubleValue];
    double kopLong = [self.theCurrentCultural.culturalGPSLongitude doubleValue];
    self.gpsCoordinatesLabel.text = [GPSCoordinates WithLatitude:kopLat WithLongitude:kopLong];
    
    if (self.theCurrentCultural.culturalObserved != NULL) {
        
        self.culturalObserved.text = self.theCurrentCultural.culturalObserved;
        
    }
    
    else {
        
        self.culturalObserved.textColor = [UIColor lightGrayColor];
        self.culturalObserved.delegate = self;
        self.culturalObserved.text = @"Enter your observation details here.";
    }
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(backButton:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if (self.theCurrentCultural.culturalDescription !=NULL) {
        
        self.culturalDescription.text = self.theCurrentCultural.culturalDescription;
    }
    
    else {
        
        self.culturalDescription.text = @"";
        
    }
    
    [self updateThumbnails:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSwipe" object:self];
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textViewShouldBeginEditing:(DALinedTextView *)textView
{
    if ([textView.text isEqualToString:@"Enter your observation details here."]) {
        self.culturalObserved.text = @"";
    }
    self.culturalObserved.textColor = [UIColor blackColor];
    return YES;
}

-(void)textViewDidChange:(DALinedTextView *)textView
{
    
    if(self.culturalObserved.text.length == 0){
        self.culturalObserved.textColor = [UIColor lightGrayColor];
        self.culturalObserved.text = @"Enter your observation details here.";
        [self.culturalObserved resignFirstResponder];
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [ProgressHUD show:@"Saving Picture . . ."];
	
    //Saving the image hangs up the UI.  GCD to offload to another thread.
    
    dispatch_queue_t imageSaveQueue = dispatch_queue_create("Image Save Queue",NULL);
    
    dispatch_async(imageSaveQueue, ^{
        
        UIImage *capturedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(capturedImage, 1.0);
        [self.theCurrentCultural setValue:imageData forKey:@"culturalPhoto"];
        
        [self updateThumbnails:self];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ProgressHUD showSuccess:@"Picture saved."];
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Private Methods

- (void)backButton:(id)sender
{
    
    if (self.theCurrentCultural.culturalDescription == nil && self.theCurrentCultural.culturalObserved==nil && self.theCurrentCultural.culturalPhoto == nil) {
        
        [self.theCurrentCultural delete];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    else if (self.theCurrentCultural.culturalDescription == nil || self.theCurrentCultural.culturalObserved == nil) {
        
        //Alert user that they didn't finished all of the required elements
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"You haven't entered all of the required information.  If you go back now, you'll loose anything you have entered.  Are you sure you want to go back?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles: @"OK", nil];
        
        [alertView show];
    }
    
    else {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (IBAction)takePhoto:(id)sender
{
    if (self.theCurrentCultural.culturalPhoto == nil) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePickerController setShowsCameraControls:YES];
            [imagePickerController setEditing:NO];
            [imagePickerController setNavigationBarHidden:YES];
            [imagePickerController setDelegate:self];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    else {
        
        PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
        
        photoViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        photoViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [photoViewController setCulturalPhotoReference:self.theCurrentCultural];
        [photoViewController setPhotoData:self.theCurrentCultural.culturalPhoto];
        [photoViewController setReportType:@"Cultural"];
        [photoViewController setPhotoEntity:@"culturalPhoto"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
    }
}

- (IBAction)saveCultural:(id)sender
{
    
    if (![self.culturalDescription.text isEqualToString:@""] && ![self.culturalObserved.text isEqualToString:@"Enter your observation details here."]) {
        
        self.theCurrentCultural.culturalDateTime = [NSDate date];
        self.theCurrentCultural.culturalDescription = self.culturalDescription.text;
        self.theCurrentCultural.culturalObserved = self.culturalObserved.text;
        
        [self.theCurrentCultural save];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else {
        
        //Alert user that they didn't finished all of the required elements
        UIAlertView *saveAlertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                message:@"You haven't entered all of the required information."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
        
        [saveAlertView show];
    }
    
}

- (void)updateThumbnails:(id)sender {
    
    if (self.theCurrentCultural.culturalPhoto != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentCultural.culturalPhoto];
        
        UIImage *thumbnail = [UIImage imageWithImage:picture scaledToSize:CGSizeMake(120, 86)];
        
        [self.photoButton setImage:thumbnail forState:UIControlStateNormal];
    }
    
    else {
        
        [self.photoButton setImage:[UIImage imageNamed:@"Picture.png"] forState:UIControlStateNormal];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Cancel"])
        {
        
        }
    else if([title isEqualToString:@"OK"])
        {
        [self.theCurrentCultural delete];
        [self.navigationController popViewControllerAnimated:NO];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end