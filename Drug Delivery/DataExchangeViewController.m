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

static DataExchangeViewController *_shareDevc;

+(DataExchangeViewController *)shareDevc {
    
    if (!_shareDevc) {
        //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //_shareSvc = [storyBoard instantiateViewControllerWithIdentifier:@"scanVC"];
        _shareDevc = [[DataExchangeViewController alloc] init];
    }
    return _shareDevc;
}


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
    //self.sendButton.enabled = NO;
    self.textField.delegate = self;
    //self.chatLabel.hidden = YES;
    self.svc = [ScanBLEViewController shareSvc];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTextFieldButton) userInfo:nil repeats:YES];
    
    if (!_shareDevc) {
        _shareDevc = self;
    }
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
    
    if ([self.svc.peripheralsArray count] > 0) {
        for (CBPeripheral *peripheral in self.svc.peripheralsArray) {
            if (peripheral.state == CBPeripheralStateConnected) {
                self.peripheral = peripheral;
                self.rxLabel.text = self.peripheral.name;
                NSLog(@"Peripheral is: %@",self.peripheral); // nslog debug message
                break;
            } 
        }
    }
    self.chatLabel.text = @"Send";
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
    //self.chatLabel.hidden = NO;
    self.chatLabel.text = self.textField.text;
    self.textField.text = @"";
    
    //implement BLE transmission
    NSString *message = self.chatLabel.text;
    NSLog(@"%@",message);
    NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
    CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
    [self.peripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
    //test
  //NSLog(@"received: %@",self.svc.rxString);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _textField) {
        
        [self didPressSendButton:self.sendButton];
    }
    return YES;
}

#pragma mark - CBCentralManager functions

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
        //self.scanButton.enabled = NO;
    }
    else if ([central state] == CBManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        //self.scanButton.enabled = YES;
        if (central == self.svc.centralManager) {//used for debug to understand the CB framework
            NSLog(@"central is equal to centralManager");
        }else {
            NSLog(@"central not equal to property!");
        }
    }
    else if ([central state] == CBManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

@end
