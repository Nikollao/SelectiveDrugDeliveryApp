//
//  SignupViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 06/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *occupationTextField;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *repeatPassword;
@property (strong, nonatomic) NSString *occupation;

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong ,nonatomic) NSMutableArray *keys;

@property (strong, nonatomic) NSMutableDictionary *signupDictionary;

- (IBAction)didPressSignupButton:(UIButton *)sender;

+(SignupViewController *)sharedInstance;

@end
