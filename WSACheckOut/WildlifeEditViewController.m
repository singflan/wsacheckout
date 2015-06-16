//
//  WildlifeEditViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/16/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "WildlifeEditViewController.h"
#import "PhotoViewController.h"
#import "WildLife.h"
#import "DALinedTextView.h"
#import "UIImage+Thumbnail.h"
#import "GPSCoordinates.h"
#import "ProgressHUD.h"

@interface WildlifeEditViewController ()

@end

@implementation WildlifeEditViewController

- (NSArray *)animalList {
    
    if (!_animalList) {
        _animalList = @[@" ", @"Pronghorn Antelope", @"Mule Deer", @"Elk", @"Bald Eagle", @"Golden Eagle", @"Bighorn Sheep", @"Wild Horse", @"Sage Grouse", @"Rabbit", @"Cougar", @"Bobcat", @"Marmot", @"Pika", @"Badger", @"Hawk", @"Falcon", @"Chukar Patridge", @"Giant Stonefly", @"Utah Cutthroat Trout", @"Snake", @"Lizard", @"Other (Please Specify Below)"];
    }
    return _animalList;
}

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
    
    self.wildlifeAnimal.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopSwipe" object:self];
    
    double kopLat = [self.theCurrentWildlife.animalGPSLatitude doubleValue];
    double kopLong = [self.theCurrentWildlife.animalGPSLongitude doubleValue];
    self.gpsCoordinatesLabel.text = [GPSCoordinates WithLatitude:kopLat WithLongitude:kopLong];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(backButton:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if (self.theCurrentWildlife.animalDescription != NULL) {
        
        self.wildlifeDescription.text = self.theCurrentWildlife.animalDescription;
    }
    
    else {
        
        self.wildlifeDescription.text = @"Enter your wildlife description here.";
        self.wildlifeDescription.textColor = [UIColor lightGrayColor];
        self.wildlifeDescription.delegate = self;
        
    }
    
    if ( self.theCurrentWildlife.animalObserved != nil) {
        
        self.title = self.theCurrentWildlife.animalObserved;
        
        unsigned long animalIndex = [self.animalList indexOfObject:self.theCurrentWildlife.animalObserved];
        
        [self.wildlifeAnimal selectRow:animalIndex inComponent:0 animated:YES];
        
    }
    
    else {
        
        [self.wildlifeAnimal selectRow:0 inComponent:0 animated:NO];
        self.title = @"New Wildlife";
        
    }
    
    [self updateThumbnails:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSwipe" object:self];
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter your wildlife description here."]) {
        self.wildlifeDescription.text = @"";
    }
    self.wildlifeDescription.textColor = [UIColor blackColor];
    return YES;
}

#pragma mark UITextField Delegate Methods

-(void) textViewDidChange:(UITextView *)textView {
    
    if(self.wildlifeDescription.text.length == 0){
        self.wildlifeDescription.textColor = [UIColor lightGrayColor];
        self.wildlifeDescription.text = @"Enter your wildlife description here.";
        [self.wildlifeDescription resignFirstResponder];
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [ProgressHUD show:@"Saving Picture . . ."];
    
    //Saving the image hangs up the UI.  GCD to offload to another thread.
    
    dispatch_queue_t imageSaveQueue = dispatch_queue_create("Image Save Queue",NULL);
    
    dispatch_async(imageSaveQueue, ^{
        
        UIImage *capturedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(capturedImage, 1.0);
        [self.theCurrentWildlife setValue:imageData forKey:@"animalPhoto"];
        
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

#pragma mark - PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.animalList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.animalList[row];
}


#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.wildlifeAnimalSelected = _animalList[row];
}

#pragma mark - Private Methods

- (void)backButton:(id)sender {
    
    if (self.theCurrentWildlife.animalObserved == nil && self.theCurrentWildlife.animalDescription==nil && self.theCurrentWildlife.animalPhoto == nil) {
        
        [self.theCurrentWildlife delete];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    else if (self.theCurrentWildlife.animalObserved == nil || self.theCurrentWildlife.animalDescription == nil) {
        
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

- (IBAction)takePhoto:(id)sender {
    
    if (self.theCurrentWildlife.animalPhoto == nil) {
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
        [photoViewController setWildlifePhotoReference:self.theCurrentWildlife];
        [photoViewController setPhotoData:self.theCurrentWildlife.animalPhoto];
        [photoViewController setReportType:@"WildLife"];
        [photoViewController setPhotoEntity:@"animalPhoto"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
        
    }
}

- (IBAction)saveWildlife:(id)sender {
    
    if (![self.wildlifeDescription.text isEqualToString:@""] && ![self.wildlifeDescription.text isEqualToString:@"Enter your wildlife description here."]) {
        
        self.theCurrentWildlife.animalDateTime = [NSDate date];
        self.theCurrentWildlife.animalObserved = self.wildlifeAnimalSelected;
        self.theCurrentWildlife.animalDescription = self.wildlifeDescription.text;
        
        [self.theCurrentWildlife save];
        
        [self.navigationController popViewControllerAnimated:YES];
        self.theCurrentWildlife = nil;
    }
    
    else {
        
        //Alert user that they didn't finished all of the required elements
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You haven't entered all of the required information."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        
        [alertView show];
    }
    
}

- (void)updateThumbnails:(id)sender {
    
    if (self.theCurrentWildlife.animalPhoto != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentWildlife.animalPhoto];
        
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
        [self.theCurrentWildlife delete];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
