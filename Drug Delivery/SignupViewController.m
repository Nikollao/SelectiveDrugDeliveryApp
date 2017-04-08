//
//  SignupViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 06/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

static SignupViewController *_sharedInstance;

+(SignupViewController *)sharedInstance {
    
    if (!_sharedInstance) {
        _sharedInstance = [[SignupViewController alloc] init];
    }
    return _sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fullNameTextField.delegate = self;
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repeatPasswordTextField.delegate = self;
    self.occupationTextField.delegate = self;
    
    [self hideKeyboardWhenBackgroundIsTapped];
    
    if (!_sharedInstance) {
        _sharedInstance = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void) hideKeyboard {
    
    [self.view endEditing:YES];
}

- (IBAction)didPressSignupButton:(UIButton *)sender {
    
    NSInteger username, fullname, password, repeatpass, occ;
    username = [self.userName length];
    fullname = [self.fullName length];
    password = [self.password length];
    repeatpass = [_repeatPassword length];
    occ = [_occupation length];
    
    if (username && fullname && password && repeatpass && occ && _password ==_repeatPassword) {
      
        CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
        NSError *error = nil;
        AccountHolder *newHolder = [NSEntityDescription insertNewObjectForEntityForName:@"AccountHolder" inManagedObjectContext:cdh.context];
        [cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:newHolder] error:&error];
        
        if (error) {
            
            NSLog(@"Application terminates with error %@",error);
            abort();
        }
        newHolder.userName = _userName;
        newHolder.password = _password;
        [cdh saveContext];

        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else {
        UIAlertController *alert = [[UIAlertController alloc] init];
        if (!username || !fullname || !password || !repeatpass || !occ) {
            alert = [UIAlertController alertControllerWithTitle:@"Signup Failed" message:@"Please ensure you have filled all text fields" preferredStyle:UIAlertControllerStyleAlert];
        }
        if (password != repeatpass) {
            alert = [UIAlertController alertControllerWithTitle:@"Signup Failed" message:@"Please ensure you password is typed correctly in both text fields" preferredStyle:UIAlertControllerStyleAlert];
        }
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField) {
    [self didPressSignupButton:self.signupButton];

    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.userNameTextField) {
        self.userName = _userNameTextField.text;
    }
    else if (textField == self.fullNameTextField) {
        self.fullName = _fullNameTextField.text;
    }
    else if (textField == self.passwordTextField) {
        self.password = self.passwordTextField.text;
    }
    else if (textField == self.repeatPasswordTextField) {
        self.repeatPassword = self.repeatPasswordTextField.text;
    }
    else if (textField == self.occupationTextField) {
        self.occupation = self.occupationTextField.text;
    }
}

@end
