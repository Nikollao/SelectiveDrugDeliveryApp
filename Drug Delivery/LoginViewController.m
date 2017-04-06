//
//  LoginViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 06/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.userName = [[NSString alloc] init];
    self.password = [[NSString alloc] init];
    [self hideKeyboardWhenBackgroundIsTapped];
    if (!self.loginDictionary) {
        self.loginDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"Hi"];
    }
    NSLog(@"Value = %@",[self.loginDictionary valueForKey:@"Hi"]);
    //self.loginDictionary = dictionary;
    if (!_password && !_userName) {
        self.password = [[NSUserDefaults standardUserDefaults] objectForKey:@"1"];
        self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:self.password];
    }
}

-(void) hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void) hideKeyboard {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didPressLoginButton:(UIButton *)sender {
    
    SignupViewController *svc = [SignupViewController sharedInstance];
    NSLog(@"%@, %@",svc.userName, svc.password);
    _password = svc.password;
    _userName = svc.userName;
    NSLog(@"%@, %@, %@, %@",_userName, _setUserName, _password, _setPassword);
    
    if (self.userName == self.setUserName && _password == _setPassword) {
        
        UIViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        [self.navigationController presentViewController:ViewController animated:true completion:nil];
        [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"1"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:self.password];
    }
}

#pragma mark - TextField Delegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.userNameTextField) {
        
        self.setUserName = self.userNameTextField.text;
    }
    else if (textField == self.passwordTextField) {
        
        self.setPassword = self.passwordTextField.text;
    }
    
    if ([self.userName length] > 0 && [self.password length] > 0) {
        
        [self.loginDictionary setValue:self.userName forKey:self.password];
        [[NSUserDefaults standardUserDefaults] setValue:self.loginDictionary forKey:@"Hi"];
        NSLog(@"%@",[self.loginDictionary valueForKey:@"Hi"]);
    }
}

@end
