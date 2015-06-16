//
//  UserListViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 9/3/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import "UserListViewController.h"
#import "User.h"

@interface UserListViewController ()

@end

@implementation UserListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.usersArray = [[NSMutableArray alloc]init];
    NSArray *allUsers = [User all];
    
    for (int i = 0; i < allUsers.count; i++) {
        
        User *user = [allUsers objectAtIndex:i];
        NSLog(@"%@",user.email);
        NSString *email = user.email;
        
        [self.usersArray addObject:email];
    }
    
    self.view.backgroundColor = [UIColor cloudsColor];
}

# pragma mark - TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.usersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([[self.usersArray objectAtIndex:indexPath.row] isEqualToString:[self.defaults stringForKey:@"UserName"]]) {
        
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:20.0];
    }
    
    else {
        cell.textLabel.font = [UIFont fontWithName:@"Avenir-Book" size:20.0];
    }
    
    cell.textLabel.text = [self.usersArray objectAtIndex:indexPath.row];
    

    return cell;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *selectedUser = [self.usersArray objectAtIndex:indexPath.row];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Dismiss the popup and create the new controller for the report
    if ([self.delegate respondsToSelector:@selector(setUsername:)]) {
        
        [self.delegate setUsername:selectedUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
