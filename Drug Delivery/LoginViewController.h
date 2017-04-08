//
//  LoginViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 06/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "AccountHolder.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSArray *usernames;
@property (strong, nonatomic) NSArray *passwords;

- (IBAction)didPressLoginButton:(UIButton *)sender;
- (IBAction)didPressAccountsButton:(id)sender;

- (void) fetch;

@end
