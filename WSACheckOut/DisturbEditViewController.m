//
//  DisturbEditViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/14/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "DisturbEditViewController.h"
#import "PhotoViewController.h"
#import "Disturbances.h"
#import "DALinedTextView.h"
#import "UIImage+Thumbnail.h"
#import "GPSCoordinates.h"
#import "ProgressHUD.h"

@interface DisturbEditViewController ()

@end

@implementation DisturbEditViewController

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
    
    [self.disturbDescription setEnabled:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopSwipe" object:self];
    
    double kopLat = [self.theCurrentDisturbance.disturbGPSLatitude doubleValue];
    double kopLong = [self.theCurrentDisturbance.disturbGPSLongitude doubleValue];
    self.gpsCoordinatesLabel.text = [GPSCoordinates WithLatitude:kopLat WithLongitude:kopLong];
    
    if (self.theCurrentDisturbance.disturbImpact != NULL) {
        
        self.disturbImpact.text = self.theCurrentDisturbance.disturbImpact;
    }
    
    else {
        
        self.disturbImpact.textColor = [UIColor lightGrayColor];
        self.disturbImpact.delegate = self;
        self.disturbImpact.text = @"Enter your impact description here.";
    }
    
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(backButton:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if (self.theCurrentDisturbance.disturbDescription != NULL) {
        
        self.disturbDescription.text = self.theCurrentDisturbance.disturbDescription;
    }
    
    else {
        
        self.disturbDescription.text = @"";
        
    }
    
    [self updateThumbnails];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSwipe" object:self];
}

#pragma mark UITextField Delegate Methods

- (BOOL)textViewShouldBeginEditing:(DALinedTextView *)textView
{
    if ([textView.text isEqualToString:@"Enter your impact description here."]) {
        self.disturbImpact.text = @"";
    }
    self.disturbImpact.textColor = [UIColor blackColor];
    return YES;
}

-(void)textViewDidChange:(DALinedTextView *)textView
{
    
    if(self.disturbImpact.text.length == 0){
        self.disturbImpact.textColor = [UIColor lightGrayColor];
        self.disturbImpact.text = @"Enter your impact description here.";
        [self.disturbImpact resignFirstResponder];
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
        [self.theCurrentDisturbance setValue:imageData forKey:@"disturbPhoto"];
        
        [self updateThumbnails];
        
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
    
    if (self.theCurrentDisturbance.disturbDescription == nil && self.theCurrentDisturbance.disturbImpact==nil && self.theCurrentDisturbance.disturbPhoto == nil) {
        
        [self.theCurrentDisturbance delete];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if (self.theCurrentDisturbance.disturbDescription == nil || self.theCurrentDisturbance.disturbImpact == nil) {
        
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
    
    if (self.theCurrentDisturbance.disturbPhoto == nil) {
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
        [photoViewController setDisturbancePhotoReference:self.theCurrentDisturbance];
        [photoViewController setPhotoData:self.theCurrentDisturbance.disturbPhoto];
        [photoViewController setReportType:@"Disturbances"];
        [photoViewController setPhotoEntity:@"disturbPhoto"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
    }
    
}

- (IBAction)selectCategoryList:(id)sender {
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                              delegate: self
                                                     cancelButtonTitle: nil
                                                destructiveButtonTitle: nil
                                                     otherButtonTitles: @"OHV Incursion", @"Litter/Human Waste", @"Damaged/Destroyed BLM Sign", @"Campsite/Fire Ring", @"Damaged/Destroyed BLM Gate/Kiosk", @"Wood Cutting", @"Graffiti", @"Active Mining Activities", @"Climbing Bolts Attached to Rock", @"Other User-created Disturbance", nil];
    
    [actionSheet showFromRect: self.categoryButton.frame inView: self.categoryButton.superview animated: YES];
}

- (IBAction)saveDisturbance:(id)sender
{
    
    if (![self.disturbDescription.text isEqualToString:@""] && ![self.disturbImpact.text isEqualToString:@"Enter your impact description here."]) {
        
        self.theCurrentDisturbance.disturbDateTime = [NSDate date];
        self.theCurrentDisturbance.disturbDescription = self.disturbDescription.text;
        self.theCurrentDisturbance.disturbImpact = self.disturbImpact.text;
        
        [self.theCurrentDisturbance save];
        
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

- (void)updateThumbnails {
    
    if (self.theCurrentDisturbance.disturbPhoto != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentDisturbance.disturbPhoto];
        
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
        [self.theCurrentDisturbance delete];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"OHV Incursion"]) {
        self.disturbDescription.text = @"OHV Incursion"; }
    if ([buttonTitle isEqualToString:@"Litter/Human Waste"]) {
        self.disturbDescription.text = @"Litter/Human Waste"; }
    if ([buttonTitle isEqualToString:@"Damaged/Destroyed BLM Sign"]) {
        self.disturbDescription.text = @"Damaged/Destroyed BLM Sign"; }
    if ([buttonTitle isEqualToString:@"Campsite/Fire Ring"]) {
        self.disturbDescription.text = @"Campsite/Fire Ring"; }
    if ([buttonTitle isEqualToString:@"Damaged/Destroyed BLM Gate/Kiosk"]) {
        self.disturbDescription.text = @"Damaged/Destroyed BLM Gate/Kiosk"; }
    if ([buttonTitle isEqualToString:@"Wood Cutting"]) {
        self.disturbDescription.text = @"Wood Cutting"; }
    if ([buttonTitle isEqualToString:@"Graffiti"]) {
        self.disturbDescription.text = @"Graffiti"; }
    if ([buttonTitle isEqualToString:@"Active Mining Activities"]) {
        self.disturbDescription.text = @"Active Mining Activities"; }
    if ([buttonTitle isEqualToString:@"Climbing Bolts Attached to Rock"]) {
        self.disturbDescription.text = @"Climbing Bolts Attached to Rock"; }
    if ([buttonTitle isEqualToString:@"Other User-created Disturbance"]) {
        self.disturbDescription.text = @"Other User-created Disturbance"; }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
