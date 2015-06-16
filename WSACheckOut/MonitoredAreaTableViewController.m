//
//  MonitoredAreaSelectViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 8/28/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "MonitoredAreaTableViewController.h"
#import "KOPViewController.h"
#import "Report.h"
#import "User.h"
#import "KOP.h"

@interface MonitoredAreaTableViewController ()

@end

@implementation MonitoredAreaTableViewController

@synthesize delegate;
@synthesize areasArray = _areasArray;
@synthesize workingArray = _workingArray;
@synthesize uniqueAreas = _uniqueAreas;
@synthesize selectedMonitoredArea = _selectedMonitoredArea;
@synthesize selectedFieldOffice = _selectedFieldOffice;
@synthesize theNewReport = _theNewReport;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.areasArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MontanaListOfWSA" ofType:@"plist"]];
    self.uniqueAreas = [[NSSet alloc] initWithArray:[self.areasArray valueForKey:@"WSA"]];
    self.workingArray = [[self.uniqueAreas allObjects]mutableCopy];
    self.view.backgroundColor = [UIColor cloudsColor];
    
}

# pragma mark - TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.uniqueAreas count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:20.0];
    cell.textLabel.text = [self.workingArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //set up the variables for the new report

    NSMutableString *reportTitleString = [[NSMutableString alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yy hh:mm:ss a"];
    NSDate *reportDate =[NSDate date];
    
    //create a new report
    self.theNewReport = [Report create];
    [self.theNewReport setCreatedReport:[User where:@{@"email" : [self.defaults objectForKey:@"ActiveUser"]}].lastObject];
    
    self.selectedMonitoredArea = [self.workingArray objectAtIndex:indexPath.row];
    
    int areasCount = [self.areasArray count];
    
    for (int i=0; i < areasCount; i++) {
        
        if ([[self.areasArray[i] objectForKey:@"WSA"] isEqualToString:self.selectedMonitoredArea]) {
            
            self.selectedFieldOffice = [self.areasArray[i] objectForKey:@"FieldOffice"];
            
            //Iterate through the list and create a default KOP for each one in the list
            KOP *newKOP = [KOP create];
            [newKOP setReported:self.theNewReport];
            [newKOP setKopName:[self.areasArray[i] objectForKey:@"KOP"]];
            [newKOP setKopGPSLatitude:[self.areasArray[i] objectForKey:@"Lat"]];
            [newKOP setKopGPSLongitude:[self.areasArray[i] objectForKey:@"Long"]];
            [newKOP setKopDateTime:reportDate];
            
            [newKOP save];
        }
    }
    
    [self.theNewReport setWsaName:self.selectedMonitoredArea];
    [self.theNewReport setDateTimeStamp:reportDate];
    [self.theNewReport setBlmDistrict:self.selectedFieldOffice];
    [self.theNewReport setReportStatus:@"new"];
    
    [reportTitleString appendString: self.selectedMonitoredArea];
    [reportTitleString appendString:@" "];
    [reportTitleString appendString:[dateFormatter stringFromDate:reportDate]];
    [self.theNewReport setReportTitle:reportTitleString];

    [self.theNewReport save];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Dismiss the popup and create the new controller for the report
    if ([self.delegate respondsToSelector:@selector(loadReport:)]) {
        
        [self.delegate loadReport:self.theNewReport];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
