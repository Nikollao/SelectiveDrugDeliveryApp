//
//  DataExchangeViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 26/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "DataExchangeViewController.h"

@interface DataExchangeViewController ()

@end

@implementation DataExchangeViewController
/*
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                 invocation:(NSInvocation *)invocation
                                    repeats:(BOOL)yesOrNo {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:nil interval:ti target:self selector:@selector(updateTextFieldButton) userInfo:nil repeats:YES];
    return timer;
}
*/
- (void)updateTextFieldButton {
    
    if ([self.textField.text isEqualToString:@""]) {
        self.sendButton.enabled = NO;
    }if ([self.textField.text length] > 0) {
        self.sendButton.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    // self.sendButton.enabled = NO;
    self.textField.delegate = self;
    self.chatLabel.hidden = YES;
    self.rxLabel.text = self.rxString;
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTextFieldButton) userInfo:nil repeats:YES];
}

-(void)hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void)hideKeyboard {
    
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)done:(id)sender {
    
    [self hideKeyboard];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)keyboardWillShow {
    
    if (self.textFieldView.frame.origin.y >= 0) {
        
        [self setViewMovedUp:YES];
    }
    else if (self.textFieldView.frame.origin.y < 0) {
        
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    
    if (self.textFieldView.frame.origin.y >= 0) {
        
        [self setViewMovedUp:YES];
    }
    else if (self.textFieldView.frame.origin.y < 0) {
        
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.textField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.textFieldView.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
   /*
    }*/
}

/*- (void)textFieldDidEngEditing:(UITextField *)sender
{
    if ([self.textField.text isEqualToString:@""]) {
        self.sendButton.enabled = NO;
    }if ([self.textField.text length] > 0) {
        self.sendButton.enabled = YES;
    }
}*/

-(void)setViewMovedUp:(BOOL)movedUp {
    
    CGRect rect = self.textFieldView.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        //rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.textFieldView.frame = rect;
}

- (IBAction)didPressSendButton:(id)sender {
    
    //[self hideKeyboard];
    self.chatLabel.hidden = NO;
    self.chatLabel.text = self.textField.text;
    self.textField.text = @"";
}
@end