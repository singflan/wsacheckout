//
//  PlantsEditViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 1/28/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "PlantsEditViewController.h"
#import "PhotoViewController.h"
#import "PlantLife.h"
#import "DALinedTextView.h"
#import "UIImage+Thumbnail.h"
#import "GPSCoordinates.h"
#import "ProgressHUD.h"

@interface PlantsEditViewController ()

@end

@implementation PlantsEditViewController

- (NSArray *)plantList {
    
    if (!_plantList) {

            _plantList = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UtahSensitivePlantList" ofType:@"plist"]];

    }
    return _plantList;
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
    
    self.plantlifePlants.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StopSwipe" object:self];
    
    double kopLat = [self.theCurrentPlantlife.plantGPSLatitude doubleValue];
    double kopLong = [self.theCurrentPlantlife.plantGPSLongitude doubleValue];
    self.gpsCoordinatesLabel.text = [GPSCoordinates WithLatitude:kopLat WithLongitude:kopLong];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(backButton:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if (self.theCurrentPlantlife.plantDescription != NULL) {
        
        self.plantlifeDescription.text = self.theCurrentPlantlife.plantDescription;
    }
    
    else {
        
        self.plantlifeDescription.text = @"Enter your plantlife description here.";
        self.plantlifeDescription.textColor = [UIColor lightGrayColor];
        self.plantlifeDescription.delegate = self;
        
    }
    
    if ( self.theCurrentPlantlife.plantObserved != NULL) {
        
        NSMutableArray *plantNames = [[NSMutableArray alloc] init];
        NSString *plantName = [[NSString alloc] init];
        int i;
        
        for (i=0; self.plantList.count > i; i++) {
            
        NSString *genusName = [self.plantList[i] valueForKey:@"Genus"];
        NSString *speciesName = [self.plantList[i] valueForKey:@"Species"];
        NSString *varietyName = [self.plantList[i] valueForKey:@"Variety"];
        
        plantName = [NSString stringWithFormat:@"%@ %@ %@",genusName, speciesName, varietyName];
        
        [plantNames addObject:plantName];
        
        }
                                 
        int plantIndex = [plantNames indexOfObject:self.theCurrentPlantlife.plantObserved];
        
        [self.plantlifePlants selectRow:plantIndex inComponent:0 animated:YES];
        
    }
    
    else {
        
        [self.plantlifePlants selectRow:0 inComponent:0 animated:NO];
        self.title = @"New Plantlife";
        
    }
    
    [self updateThumbnails:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartSwipe" object:self];
}

#pragma mark - UITextField Delegate Methods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Enter your plantlife description here."]) {
        self.plantlifeDescription.text = @"";
    }
    self.plantlifeDescription.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView {
    
    if(self.plantlifeDescription.text.length == 0){
        self.plantlifeDescription.textColor = [UIColor lightGrayColor];
        self.plantlifeDescription.text = @"Enter your plantlife description here.";
        [self.plantlifeDescription resignFirstResponder];
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
        [self.theCurrentPlantlife setValue:imageData forKey:@"plantPhoto"];
        
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
    
    return self.plantList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *plantName = [[NSString alloc] init];
    NSString *genusName = [[NSString alloc] init];
    NSString *speciesName = [[NSString alloc] init];
    NSString *varietyName = [[NSString alloc] init];
    
    genusName = [[self.plantList objectAtIndex:row] valueForKey:@"Genus"];
    speciesName = [[self.plantList objectAtIndex:row] valueForKey:@"Species"];
    varietyName = [[self.plantList objectAtIndex:row] valueForKey:@"Variety"];
    
    plantName = [NSString stringWithFormat:@"%@ %@ %@",genusName, speciesName, varietyName];
    return plantName;
}


#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *plantName = [[NSString alloc] init];
    NSString *genusName = [[NSString alloc] init];
    NSString *speciesName = [[NSString alloc] init];
    NSString *varietyName = [[NSString alloc] init];
    
    genusName = [[self.plantList objectAtIndex:row] valueForKey:@"Genus"];
    speciesName = [[self.plantList objectAtIndex:row] valueForKey:@"Species"];
    varietyName = [[self.plantList objectAtIndex:row] valueForKey:@"Variety"];
    
    plantName = [NSString stringWithFormat:@"%@ %@ %@",genusName, speciesName, varietyName];

    self.plantlifePlantSelected = plantName;
}

#pragma mark - Private Methods

- (void)backButton:(id)sender {
    
    if (self.theCurrentPlantlife.plantObserved == nil && self.theCurrentPlantlife.plantDescription==nil && self.theCurrentPlantlife.plantPhoto == nil) {
        
        [self.theCurrentPlantlife delete];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    else if (self.theCurrentPlantlife.plantObserved == nil || self.theCurrentPlantlife.plantDescription == nil) {
        
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
    
    if (self.theCurrentPlantlife.plantPhoto == nil) {
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
        [photoViewController setPlantlifePhotoReference:self.theCurrentPlantlife];
        [photoViewController setPhotoData:self.theCurrentPlantlife.plantPhoto];
        [photoViewController setReportType:@"PlantLife"];
        [photoViewController setPhotoEntity:@"plantPhoto"];
        
        [self presentViewController:photoViewController animated:YES completion:nil];
    }
    
}

- (IBAction)savePlantlife:(id)sender {
    
    if (![self.plantlifeDescription.text isEqualToString:@""] && ![self.plantlifeDescription.text isEqualToString:@"Enter your plantlife description here."]) {
        
        self.theCurrentPlantlife.plantDateTime = [NSDate date];
        self.theCurrentPlantlife.plantObserved = self.plantlifePlantSelected;
        self.theCurrentPlantlife.plantDescription = self.plantlifeDescription.text;
        
        [self.theCurrentPlantlife save];
        self.theCurrentPlantlife = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
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
    
    if (self.theCurrentPlantlife.plantPhoto != nil) {
        
        UIImage *picture = [[UIImage alloc] init];
        picture = [UIImage imageWithData:self.theCurrentPlantlife.plantPhoto];
        
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
    [self.theCurrentPlantlife delete];
    [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
