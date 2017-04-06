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
    
    if (!_signupDictionary) {
        _signupDictionary = [NSMutableDictionary dictionaryWithCapacity:15];
    }
    if (!_objects) {
        _objects = [NSMutableArray array];
    }
    if (!_keys) {
        _keys = [NSMutableArray arrayWithCapacity:15];
    }
    
    self.fullNameTextField.delegate = self;
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repeatPasswordTextField.delegate = self;
    self.occupationTextField.delegate = self;
    
    [self hideKeyboardWhenBackgroundIsTapped];
    _sharedInstance = self;
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
    
    if (username && fullname && password && repeatpass && occ) {
        if (_password == _repeatPassword) {
            
            [_objects addObject:self.userName];
            [_keys addObject:self.password];
            [self.signupDictionary setObject:_objects forKey:_keys];
            
            NSArray *array = _signupDictionary[_keys];
            NSString *string = [array firstObject];
            NSLog(@"%@, %@",string,[_keys objectAtIndex:0]);
            [self.navigationController popViewControllerAnimated:YES];
        }
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
