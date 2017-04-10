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
    self.passwordTextField.secureTextEntry = YES;
    [self hideKeyboardWhenBackgroundIsTapped];
    
    if (!_usernames) {
        _usernames = [NSArray array];
    }
    if (!_passwords) {
        _passwords = [NSArray array];
    }
}

-(void) fetch {
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:@"AccountHolder"];
    NSFetchRequest *passwordRequest = [NSFetchRequest fetchRequestWithEntityName:@"AccountHolder"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:YES];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"password" ascending:YES];
    
    [userRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [passwordRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    
    [passwordRequest setFetchBatchSize:15];
    [passwordRequest setFetchBatchSize:15]; // very good practice to make the fetch more efficient
    
    _usernames = [cdh.context executeFetchRequest:userRequest error:nil];
    _passwords = [cdh.context executeFetchRequest:passwordRequest error:nil];
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
    
    if ([_userName length] && [_password length]) {
        
        [self fetch];
        if ([_usernames count] && [_passwords count]) {
            
            BOOL  found = NO;
            NSInteger max = [_usernames count];
            NSLog(@"max = %ld",max);
            
            //CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
            AccountHolder *holder = [[AccountHolder alloc] init];
            
            for (int i = 0; i < max; i++) {
                holder = [_usernames objectAtIndex:i];
                holder = [_passwords objectAtIndex:i];
                
                if ([_userName isEqualToString:holder.userName] && [_password isEqualToString:holder.password]) {
                    found = YES;
                    break;
                }
                NSLog(@"array username: %@",[_usernames objectAtIndex:i]);
                NSLog(@"array password: %@",[_passwords objectAtIndex:i]);
            }
            
            if (found) {
                
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
                [self.navigationController presentViewController:vc animated:true completion:nil];
            }
            else {
                [self userNameNotMatchesPassword];
            }
        }
        else {
            [self userNameNotMatchesPassword];
        }
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log in Failed" message:@"Ensure required text fields are filled" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) userNameNotMatchesPassword {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log in Failed" message:@"Username and password do not match" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)didPressAccountsButton:(id)sender {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adminstrator Access" message:@"Password required" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @" Please enter password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Access Accounts table" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        NSLog(@"text is: %@",textField.text);
        [self.view endEditing:YES];
        NSString *correctPassword = @"Group project";
        NSLog(@"correct password is: %@",correctPassword);
        
        if ([textField.text isEqualToString:correctPassword]) {
            
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"accounts table"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
            
            alert.message = @"Incorrect password";
            alert.textFields.firstObject.text = @"";
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TextField Delegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    if (textField == _userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField) {
        [self didPressLoginButton:self.loginButton];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.userNameTextField) {
        
        self.userName = self.userNameTextField.text;
    }
    else if (textField == self.passwordTextField) {
        
        self.password = self.passwordTextField.text;
    }
}

@end
