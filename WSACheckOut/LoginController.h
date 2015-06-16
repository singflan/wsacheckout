//
//  LoginController.h
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ACSimpleKeychain/ACSimpleKeychain.h>
#import <FXReachability/FXReachability.h>
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import "UserListViewController.h"

@class UserListViewController;

@interface LoginController : UIViewController <UITextFieldDelegate, UIPopoverControllerDelegate, SelectUsernameDelegate> {
    
    UIPopoverController *popoverController;
}

@property (nonatomic, strong) IBOutlet UIView * infoView;
@property (nonatomic, strong) IBOutlet UITextField * usernameField;
@property (nonatomic, strong) IBOutlet UITextField * passwordField;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton * forgotButton;
@property (nonatomic, strong) IBOutlet UIImageView * headerImageView;
@property (nonatomic, strong) IBOutlet UILabel * infoLabel;
@property (nonatomic, strong) NSUserDefaults *defaults;


- (void)setUsername:(NSString *)selectedUserName;
- (IBAction)createNewUser:(id)sender;
- (IBAction)forgotPassword:(id)sender;


@end
