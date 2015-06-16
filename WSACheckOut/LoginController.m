//
//  LoginController4.m
//  ADVFlatUI
//
//  Created by Tope on 30/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "LoginController.h"
#import "CreateLoginViewController.h"
#import "User.h"


@interface LoginController ()

@end

@implementation LoginController

@synthesize defaults = _defaults;

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
	
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    UIColor* mainColor = [UIColor colorWithRed:249.0/255 green:223.0/255 blue:244.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:62.0/255 green:28.0/255 blue:55.0/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.placeholder = @"Email Address";
    self.usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    self.usernameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.usernameField.layer.borderWidth = 1.0f;
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView = leftView;
    self.usernameField.delegate = self;
    
    
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.placeholder = @"Password";
    self.passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    self.passwordField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.passwordField.layer.borderWidth = 1.0f;
    
    
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView = leftView2;
    
    self.loginButton.backgroundColor = darkColor;
    self.loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(closeLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.forgotButton.backgroundColor = [UIColor clearColor];
    self.forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [self.forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    [self.forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    self.infoLabel.textColor =  [UIColor darkGrayColor];
    self.infoLabel.font =  [UIFont fontWithName:boldFontName size:14.0f];
    self.infoLabel.text = @"Welcome, Please Login.";
    
    self.infoView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //Check to see if we are already logged in.
    if ([[self.defaults valueForKey:@"LoginStatus"] isEqualToString:@"YES"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    else {
        
        if (![[self.defaults stringForKey:@"ActiveUser"] length] == 0) {
            
            self.infoLabel.text = @"Welcome back.  Please Login.";
            
            self.usernameField.text = [self.defaults stringForKey:@"ActiveUser"];
            
            [self.passwordField becomeFirstResponder];
            
        }
    }
}

- (void)closeLogin:(id)sender {
    
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    
    NSDictionary *credentials = [[NSDictionary alloc] init];
    credentials = [keychain credentialsForIdentifier:self.usernameField.text service:@"WSAcheckOut"];
    
    //Verify the password with the stored password in the keychain.
    //*NOTE*  There is a provision for an override password here as requested by the client.
    
    if ([self.passwordField.text isEqualToString:[credentials valueForKey:ACKeychainPassword]] || [self.passwordField.text isEqualToString:@"Intern12"]) {
        
        //Keep track of who just logged in
        [self.defaults setObject:self.usernameField.text forKey:@"ActiveUser"];
        NSMutableString *userName = [[NSMutableString alloc] init];
        
        User *currentUser = [User where:@{@"email" : [self.defaults stringForKey:@"ActiveUser"]}].lastObject;
        
        [userName appendString:currentUser.firstName];
        [userName appendString:@" "];
        [userName appendString:currentUser.lastName];
        
        [self.defaults setObject:userName forKey:@"UserName"];
        [self.defaults setValue:@"YES" forKey:@"LoginStatus"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else {
        
        //Alert user that the email address and password didn't match an already exisiting user.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                              message:@"The email address and\npassword didn't match.\nPlease try again."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];

        [alertView show];
    }
    
}

- (IBAction)createNewUser:(id)sender {
    
    UIStoryboard *newLoginStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    CreateLoginViewController *createLoginViewController = [newLoginStoryboard instantiateViewControllerWithIdentifier:@"CreateLogin"];

    [self presentViewController:createLoginViewController animated:YES completion:nil];

}

- (IBAction)forgotPassword:(id)sender {
    
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    NSDictionary *credentials = [[NSDictionary alloc] init];
    credentials = [keychain credentialsForIdentifier:self.usernameField.text service:@"WSAcheckOut"];
    
    BOOL reachable = [FXReachability isReachable];
    NSString *password = [credentials valueForKey:ACKeychainPassword];
    User *testUser = [User where:@{@"email" : self.usernameField.text}].lastObject;
    NSString *testEmailUser = testUser.email;
    
    if (testEmailUser != NULL) {
        
        if (![self.usernameField.text isEqualToString:@""]) {
            
            if (reachable == YES) {
                
                //create SMTP Object
                SKPSMTPMessage *message = [[SKPSMTPMessage alloc] init];
                message.relayHost = @"mail.aceintern.org";
                message.login = @"wsacheckout@aceintern.org";
                message.pass = @"Intern12";
                message.requiresAuth = TRUE;
                
                //build the header
                message.fromEmail = @"wsacheckout@aceintern.org";
                message.toEmail = self.usernameField.text;
                message.subject = @"Your WSA CheckOut Password";
                
                //build the body
                NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                                           [NSString stringWithFormat: @"\nYour WSA Checkout password is %@\nIf you continue to have problems,\nplease contact us at wsa@usaconservation.org\n", password],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
                
                message.parts = [NSArray arrayWithObject:plainPart];
                
                //send the email asynchronously
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [message send];
                });
                
                //Alert user that the email was sent
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password Sent"
                                                                    message:@"The password was sent\nto your email address.\nPlease check your email."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                
                [alertView show];
            }
            
            else {
                
                //Alert user that there wasn't a network connection to send the email.
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password Not Sent"
                                                                    message:@"Sorry, your password\n could not be sent.\nPlease check your connection."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                
                [alertView show];
            }
        }
        
        else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"Please enter your email address.\n"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        }
    }
    
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:@"That email is not on this device.\nPlease check your email address,\nand try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        
        [alertView show];
    }
}

- (void)messageSent:(SKPSMTPMessage *)message
{

}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    
    NSLog(@"Error sending email to %@: The error was %@", self.usernameField.text, error);
    
    //Alert user that there wasn't a network connection to send the email.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password Not Sent"
                                                        message:@"Sorry, your password\n could not be sent.\nPlease check your connection."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    
    if (aTextField == self.passwordField) {
    [aTextField resignFirstResponder];
    [self closeLogin:nil];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField {
    
    if (aTextField == self.usernameField && [User count] != 0) {
        
        if(popoverController == nil){   //make sure popover isn't displayed more than once in the view
            
            UserListViewController *userListViewController = [[UserListViewController alloc] init];
            userListViewController.delegate = self;
            
            userListViewController.preferredContentSize = CGSizeMake(300, 200);
            
            popoverController = [[UIPopoverController alloc]initWithContentViewController:userListViewController];
        }
        
        [popoverController presentPopoverFromRect:aTextField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        popoverController.delegate = self;
        return NO; // tells the textfield not to start its own editing process (ie show the keyboard)
    }
    else {
        return YES;
    }
}

- (void)setUsername:(NSString *)selectedUserName {
    
    if (popoverController) {
        
        [popoverController dismissPopoverAnimated:YES];
    }
    
    self.usernameField.text = selectedUserName;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
