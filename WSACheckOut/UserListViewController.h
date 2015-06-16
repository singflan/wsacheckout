//
//  UserListViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 9/3/14.
//  Copyright (c) 2014 Timothy England. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@protocol SelectUsernameDelegate <NSObject>

-(void)setUsername:(NSString *)selectedUserName;

@end

@interface UserListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id <SelectUsernameDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *usersArray;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end
