//
//  SidebarController.m
//  ADVFlatUI
//
//  Created by Tope on 05/06/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "SidebarController.h"
#import "SidebarCell.h"
#import "BDBSplitViewController.h"
#import "DetailReportViewController.h"
#import "LoginController.h"
#import "Report.h"
#import "User.h"

@interface SidebarController ()

@end

@implementation SidebarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSString* boldFontName = @"Avenir-Black";
    NSString* fontName = @"Avenir-BlackOblique";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //create the Left Nav Bar Buttons
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    [self.logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"Avenir-Black" size:17.0f],
                                    NSFontAttributeName, [UIColor midnightBlueColor],
                                    NSForegroundColorAttributeName, nil];
    [self.splitViewController.closeMasterViewButtonItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItems = @[self.splitViewController.closeMasterViewButtonItem, logoutButtonItem];
    
    self.syncButton.hidden = TRUE;
    
    if (![[defaults valueForKey:@"CurrentReportTitle"] isEqualToString: @""]) {
    
        self.logoutButton.hidden = TRUE;
    }
    
    else {
        
        self.logoutButton.hidden = FALSE;
    }
    
    self.profileNameLabel.textColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    self.profileNameLabel.font = [UIFont fontWithName:boldFontName size:14.0f];
    self.profileNameLabel.text = [defaults stringForKey:@"UserName"];
    
    self.profileEmailLabel.textColor = [UIColor colorWithRed:249.0/255 green:223.0/255 blue:244.0/255 alpha:1.0f];
    self.profileEmailLabel.font = [UIFont fontWithName:fontName size:12.0f];
    self.profileEmailLabel.text = [defaults stringForKey:@"ActiveUser"];
    
    self.profileImageView.image = [UIImage imageNamed:@"logo"];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.profileImageView.layer.borderColor = [UIColor colorWithWhite:1.0f alpha:0.5f].CGColor;
    self.profileImageView.layer.cornerRadius = 35.0f;
    
    [self populateTableViewData:self];
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger result = 0;
    
    if ([tableView isEqual:self.tableView]) {
        
        if ([self.tableViewItems count] > section) {
            
            NSMutableArray *sectionArray = [self.tableViewItems objectAtIndex:section];
            
            result = (NSInteger)[sectionArray count];
        }
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SidebarCell";
    
    SidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SidebarCell"];
    
    if (!cell) {
        
        cell = [[SidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSMutableArray *sectionArray = [self.tableViewItems objectAtIndex:indexPath.section];
    
    NSDictionary* item = sectionArray[indexPath.row];
    
    cell.titleLabel.text = item[@"title"];
    [cell.titleLabel sizeToFit];
    cell.userInteractionEnabled = NO;
    
    if (![item[@"icon"] isEqualToString:@""]) {
        
        cell.iconImageView.image = [UIImage imageNamed:item[@"icon"]];
    }
    
    else {
        
        cell.iconImageView.image = nil;
    }
    
    NSString *count = item[@"count"];
    
    if ([item[@"title"] isEqualToString:@"Total Reports"]) {
        
        cell.countLabel.backgroundColor = [UIColor cloudsColor];
        cell.countLabel.textColor = [UIColor darkTextColor];
        cell.countLabel.text = count;
    }
    
    else if ([item[@"title"] isEqualToString:@"Sent"]){
        
        cell.countLabel.backgroundColor = [UIColor greenColor];
        cell.countLabel.text = count;
        
    }
    
    else if ([item[@"title"] isEqualToString:@"Not Sent"]){
        
        cell.countLabel.backgroundColor = [UIColor yellowColor];
        cell.countLabel.textColor = [UIColor darkTextColor];
        cell.countLabel.text = count;
    }
    
    else if ([item[@"title"] isEqualToString:@"Unfinished"]){
        
        cell.countLabel.backgroundColor = [UIColor redColor];
        cell.countLabel.text = count;
    }
    
    else {
        
        cell.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:12.0f];
        cell.userInteractionEnabled = YES;
        cell.countLabel.alpha = 0;
        
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *result = nil;
    
    if ([tableView isEqual:self.tableView]) {
        
        result = [[UILabel alloc] initWithFrame:CGRectZero];
        result.font = [UIFont fontWithName:@"Avenir-LightOblique" size:12.0f];
        result.textColor = [UIColor whiteColor];
        
        switch (section) {
                
            case 1:
                
                result.text = @"  Unfinished Reports";
                break;
            
            case 2:
                result.text = @"  Ready To Send Reports";
                break;
            
            case 3:
                result.text = @"  Sent Reports";
                break;
                
            default:
                break;
        }
        
    }
    
    [result sizeToFit];
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *sectionArray = [self.tableViewItems objectAtIndex:indexPath.section];
    NSDictionary* item = sectionArray[indexPath.row];
    
    UINavigationController *navController = (UINavigationController *)self.splitViewController.detailViewController;
    DetailReportViewController *detailViewController = (DetailReportViewController *)navController.topViewController;
    
    if (![[defaults valueForKey:@"CurrentReportTitle"] isEqualToString: @""]) {
        
        self.currentReport = [Report where:@{@"reportTitle":[defaults objectForKey:@"CurrentReportTitle"]} ].lastObject;
        
        if ([self.currentReport.reportStatus isEqualToString:@"new"]) {
            
            //Alert user that they need to save the current report.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Current Report Not Saved"
                                                                message:@"The current report\nhas not been saved.\nPlease either save it, \nor cancel it."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
            
            [self.splitViewController hideMasterViewControllerAnimated:YES completion:nil];
        }
        
        else {
            
            [defaults setObject:item[@"title"] forKey:@"CurrentReportTitle"];
            
            self.selectedReport = [Report where:@{@"reportTitle": item[@"title"]}].lastObject;
            
            [defaults setObject:[self.selectedReport valueForKey:@"reportTitle"] forKey:@"CurrentReportTitle"];
            
            [self.splitViewController hideMasterViewControllerAnimated:YES completion:^{
                
                [detailViewController loadReport:self.selectedReport];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }];
        }
    }
    
    else {
        
        [defaults setObject:item[@"title"] forKey:@"CurrentReportTitle"];
        
        self.selectedReport = [Report where:@{@"reportTitle": item[@"title"]}].lastObject;
        
        [defaults setObject:[self.selectedReport valueForKey:@"reportTitle"] forKey:@"CurrentReportTitle"];
        
        [self.splitViewController hideMasterViewControllerAnimated:YES completion:^{
            
            [detailViewController loadReport:self.selectedReport];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates];
        
        NSMutableArray *sectionArray = [self.tableViewItems objectAtIndex:indexPath.section];
        NSDictionary* item = sectionArray[indexPath.row];
        
            
        /* First remove this object from the source */
        Report *report = [Report where:@{@"reportTitle": item[@"title"]}].lastObject;
        [report delete];
        
        [self.tableView endUpdates];
        [self populateTableViewData:self];
        [self.tableView reloadData];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

#pragma mark Private Methods

- (void)populateTableViewData:(id)sender {
    
    self.tableViewItems = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailAddress = [defaults stringForKey:@"ActiveUser"];
    
    NSArray *allReports = [Report where:@{@"createdReport.email" : emailAddress}];
    NSArray *sentReports = [Report where:@{@"reportStatus": @"sent", @"createdReport.email" : emailAddress}];
    NSArray *unsentReports = [Report where:@{@"reportStatus" :@"finished", @"createdReport.email" : emailAddress}];
    NSArray *unfinishedReports = [Report where:@{@"reportStatus" : @"unfinished", @"createdReport.email" : emailAddress}];
    
    NSString *totalReportCount = [NSString stringWithFormat:@"%lu", (unsigned long)allReports.count];
    NSString *sentReportCount = [NSString stringWithFormat:@"%lu", (unsigned long)sentReports.count];
    NSString *unsentReportCount = [NSString stringWithFormat:@"%lu", (unsigned long)unsentReports.count];
    NSString *unfinishedReportCount = [NSString stringWithFormat:@"%lu", (unsigned long)unfinishedReports.count];
    
    NSMutableArray *allObjects = [[NSMutableArray alloc] init];
    NSMutableArray *topObjects = [[NSMutableArray alloc] init];
    NSMutableArray *unfinishedObjects = [[NSMutableArray alloc] init];
    NSMutableArray *unsentObjects = [[NSMutableArray alloc] init];
    NSMutableArray *sentObjects = [[NSMutableArray alloc] init];
    
    if (![allReports count] == 0) {
        
        NSDictionary *totalReportItem = [NSDictionary dictionaryWithObjects:@[@"Total Reports",totalReportCount,@"check"]
                                                                    forKeys:@[@"title",@"count",@"icon" ]];
        [topObjects addObject:totalReportItem];
        
        if (![unfinishedReports count] == 0) {
            
            NSDictionary *unfinishedReportItem = [NSDictionary dictionaryWithObjects:@[@"Unfinished",unfinishedReportCount,@"check-red"]
                                                                             forKeys:@[@"title",@"count",@"icon" ]];
            [topObjects addObject:unfinishedReportItem];
            
            for (int i = 0; i < unfinishedReports.count; i++) {
                
                Report *report = [unfinishedReports objectAtIndex:i];
                
                NSString *reportTitle = report.reportTitle;
                
                NSDictionary *unfinishedItem = [NSDictionary dictionaryWithObjects:@[reportTitle,@"0",@""] forKeys:@[@"title", @"count", @"icon"]];
                
                [unfinishedObjects addObject:unfinishedItem];
            }
        }
        
        if (![unsentReports count] == 0) {
            
            self.syncButton.hidden = FALSE;
            
            NSDictionary *unsentReportItem = [NSDictionary dictionaryWithObjects:@[@"Not Sent",unsentReportCount,@"check-yellow"]
                                                                         forKeys:@[@"title",@"count",@"icon" ]];
            [topObjects addObject:unsentReportItem];
            
            for (int x = 0; x < unsentReports.count; x++) {
                
                Report *report = [unsentReports objectAtIndex:x];
                
                NSString *reportTitle = report.reportTitle;
                
                NSDictionary *unsentItem = [NSDictionary dictionaryWithObjects:@[reportTitle,@"0",@""] forKeys:@[@"title", @"count", @"icon"]];
                
                [unsentObjects addObject:unsentItem];
            }
        }
        
        if (![sentReports count] == 0) {
            
            NSDictionary *sentReportItem = [NSDictionary dictionaryWithObjects:@[@"Sent",sentReportCount,@"check-green"]
                                                                       forKeys:@[@"title",@"count",@"icon" ]];
            [topObjects addObject:sentReportItem];
            
            for (int y = 0; y < sentReports.count; y++) {
                
                Report *report = [sentReports objectAtIndex:y];
                
                NSString *reportTitle = report.reportTitle;
                
                NSDictionary *sentItem = [NSDictionary dictionaryWithObjects:@[reportTitle,@"0",@""] forKeys:@[@"title", @"count", @"icon"]];
                
                [sentObjects addObject:sentItem];
            }
        }
    }
    
    [allObjects addObject:topObjects];
    [allObjects addObject:unfinishedObjects];
    [allObjects addObject:unsentObjects];
    [allObjects addObject:sentObjects];
    self.tableViewItems = allObjects;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)syncReports:(id)sender {
    
    

}

- (void)logout:(id)sender {
    
    [self.splitViewController hideMasterViewControllerAnimated:YES completion:nil];
    
    //set the ActiveUser to nothing
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"NO" forKey:@"LoginStatus"];
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginController* loginViewController = [loginStoryboard instantiateViewControllerWithIdentifier:@"Login"];
    
    [self presentViewController:loginViewController animated:YES completion:nil];
    loginViewController.view.superview.center = CGPointMake(roundf(self.view.center.x), roundf(self.view.center.y));
    
}

- (IBAction)fixData:(id)sender {
    
    [self.tableView beginUpdates];
    NSArray *newReports = [Report where:@"reportStatus == 'new'"];
    
    for (int i = 0; i < newReports.count; i++) {
        
        Report *report = [newReports objectAtIndex:i];
        report.reportStatus = @"unfinished";
    }
    
    [self.tableView endUpdates];
    [self populateTableViewData:self];
    [self.tableView reloadData];
    
}
@end
