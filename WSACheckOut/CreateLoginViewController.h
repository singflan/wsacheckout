//
//  CreateLoginViewController.h
//  WSACheckOut
//
//  Created by Timothy England on 9/5/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ACSimpleKeychain/ACSimpleKeychain.h>
#import <QuartzCore/QuartzCore.h>

@interface CreateLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *createLoginFirstName;
@property (strong, nonatomic) IBOutlet UITextField *createLoginLastName;
@property (strong, nonatomic) IBOutlet UITextField *createLoginEmail;
@property (strong, nonatomic) IBOutlet UITextField *createLoginConfirmEmail;
@property (strong, nonatomic) IBOutlet UITextField *createLoginPassword;
@property (strong, nonatomic) IBOutlet UITextField *createLoginPasswordConfirm;
@property (strong, nonatomic) IBOutlet UIButton *createUserButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelUserButton;
@property (strong, nonatomic) IBOutlet UILabel *createNewUserLabel;

- (IBAction)createUserAccount:(id)sender;
- (IBAction)cancelCreateUserAccount:(id)sender;

@end
