//
//  CreateLoginViewController.m
//  WSACheckOut
//
//  Created by Timothy England on 9/5/13.
//  Copyright (c) 2013 American Conservation Experience. All rights reserved.
//

#import "CreateLoginViewController.h"
#import "User.h"

@interface CreateLoginViewController ()

@end

@implementation CreateLoginViewController

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
	
    UIColor* mainColor = [UIColor colorWithRed:249.0/255 green:223.0/255 blue:244.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:62.0/255 green:28.0/255 blue:55.0/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
    self.createNewUserLabel.font = [UIFont fontWithName:boldFontName size:15.0f];
    
    self.createLoginFirstName.backgroundColor = [UIColor whiteColor];
    self.createLoginFirstName.font = [UIFont fontWithName:fontName size:16.0f];
    self.createLoginFirstName.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.createLoginFirstName.layer.borderWidth = 1.0f;
    
    self.createLoginLastName.backgroundColor = [UIColor whiteColor];
    self.createLoginLastName.font = [UIFont fontWithName:fontName size:16.0f];
    self.createLoginLastName.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.createLoginLastName.layer.borderWidth = 1.0f;
    
    self.createLoginEmail.backgroundColor = [UIColor whiteColor];
    self.createLoginEmail.font = [UIFont fontWithName:fontName size:16.0f];
    self.createLoginEmail.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.createLoginEmail.layer.borderWidth = 1.0f;
    
    self.createLoginConfirmEmail.backgroundColor = [UIColor whiteColor];
    self.createLoginConfirmEmail.font = [UIFont fontWithName:fontName size:16.0f];
    self.createLoginConfirmEmail.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.createLoginConfirmEmail.layer.borderWidth = 1.0f;
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.createLoginFirstName.leftViewMode = UITextFieldViewModeAlways;
    self.createLoginFirstName.leftView = leftView;
    
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.createLoginLastName.leftViewMode = UITextFieldViewModeAlways;
    self.createLoginLastName.leftView = leftView2;
    
    UIView* leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.createLoginEmail.leftViewMode = UITextFieldViewModeAlways;
    self.createLoginEmail.leftView = leftView3;
    
    UIView* leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.createLoginConfirmEmail.leftViewMode = UITextFieldViewModeAlways;
    self.createLoginConfirmEmail.leftView = leftView4;
    
    self.createLoginPassword.backgroundColor = [UIColor whiteColor];
    self.createLoginPassword.font = [UIFont fontWithName:fontName size:16.0f];
    self.createLoginPassword.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.createLoginPassword.layer.borderWidth = 1.0f;
    
    self.createLoginPasswordConfirm.backgroundColor = [UIColor whiteColor];
    self.createLoginPasswordConfirm.font = [UIFont fontWithName:fontName size:16.0f];
    self.createLoginPasswordConfirm.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    self.createLoginPasswordConfirm.layer.borderWidth = 1.0f;
    
    UIView* leftView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.createLoginPassword.leftViewMode = UITextFieldViewModeAlways;
    self.createLoginPassword.leftView = leftView5;
    
    UIView* leftView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    self.createLoginPasswordConfirm.leftViewMode = UITextFieldViewModeAlways;
    self.createLoginPasswordConfirm.leftView = leftView6;
  
    self.createUserButton.backgroundColor = darkColor;
    self.createUserButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [self.createUserButton setTitle:@"CREATE" forState:UIControlStateNormal];
    [self.createUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.createUserButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [self.createUserButton addTarget:self action:@selector(createUserAccount:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (IBAction)createUserAccount:(id)sender {
    
    //First check to see if all of fields are filled out correctly
    
    if ([self.createLoginPassword.text isEqualToString: self.createLoginPasswordConfirm.text]) {
        
        if ([self.createLoginEmail.text isEqualToString: self.createLoginConfirmEmail.text]) {
            
            if ([self.createLoginFirstName.text isEqualToString: @""] || [self.createLoginLastName.text isEqualToString: @""] || [self.createLoginEmail.text isEqualToString: @""]) {
                
                //Alert user that they need to fill in all of the info
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"All of the fields are required\nPlease enter all\nof the requested information."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                
                [alertView show];
                
            }
            
            else {
                
                //TODO check to make sure it's a unique user
                NSArray *uniqueUser = [User where:@{@"email" : self.createLoginEmail.text}];
                
                if (uniqueUser.count != 0 ) {
                    
                    //Alert user that the email address is already taken
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                        message:@"This email address\nhas already been registered.\nPlease use a different email address."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles: nil];
                    
                    [alertView show];
                }
                
                else {
                    
                    //Create the user
                    User *newUser = [User create];
                    newUser.firstName = self.createLoginFirstName.text;
                    newUser.lastName = self.createLoginLastName.text;
                    newUser.email = self.createLoginEmail.text;
                    
                    
                    //Store the password in the keychain
                    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
                    [keychain storeUsername:self.createLoginEmail.text password:self.createLoginPassword.text identifier:self.createLoginEmail.text expirationDate:nil forService:@"WSAcheckOut"];
                    
                    //Save the user in the database
                    [newUser save];
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.createLoginEmail.text forKey:@"ActiveUser"];
                    
                    NSMutableString *userName = [[NSMutableString alloc] init];
                    
                    [userName appendString:newUser.firstName];
                    [userName appendString:@" "];
                    [userName appendString:newUser.lastName];
                    
                    [defaults setObject:userName forKey:@"UserName"];
                    [defaults setValue:@"YES" forKey:@"LoginStatus"];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }
        }
        else {
            //Alert user that they need to fill in all of the info
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email Address Doesn't Match"
                                                                message:@"Your email address fields didn't match.\nPlease re-enter your email address."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
            
        }
    }
    
    else {
        //Alert user that they need to fill in all of the info
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Passwords Don't Match"
                                                            message:@"Your password fields didn't match.\nPlease re-enter your password."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        
        [alertView show];
        
    }
}

- (IBAction)cancelCreateUserAccount:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    
    if (aTextField == self.createLoginFirstName) {
        [aTextField resignFirstResponder];
        [self.createLoginLastName becomeFirstResponder];
    }
    
    if (aTextField == self.createLoginLastName) {
        [aTextField resignFirstResponder];
        [self.createLoginEmail becomeFirstResponder];
    }
    
    if (aTextField == self.createLoginEmail) {
        
        if ([self NSStringIsValidEmail:self.createLoginEmail.text] == TRUE) {
        [aTextField resignFirstResponder];
        [self.createLoginConfirmEmail becomeFirstResponder];
        }
        else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                                message:@"Your email address\nisn't a valid format.\nPlease re-enter\nyour email address."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        }
    }
    
    if (aTextField == self.createLoginConfirmEmail) {
        [aTextField resignFirstResponder];
        [self.createLoginPassword becomeFirstResponder];
    }
    
    if (aTextField == self.createLoginPassword) {
        [aTextField resignFirstResponder];
        [self.createLoginPasswordConfirm becomeFirstResponder];
    }
    
    if (aTextField == self.createLoginPasswordConfirm) {
        [aTextField resignFirstResponder];
        [self createUserAccount:nil];
    }
    
    return YES;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
