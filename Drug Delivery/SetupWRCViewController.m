//
//  SetupWRCViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 11/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "SetupWRCViewController.h"

@interface SetupWRCViewController ()

@end

@implementation SetupWRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drugPickerTextField.delegate = self;
    self.percentagePickerTextField.delegate = self;
    [self hideKeyboardWhenBackgroundIsTapped];
    _drugPickerTextField.chambers = self.chambers;
    
    NSArray *percentages = [NSArray arrayWithObjects:@"25",@"50",@"75",@"100", nil];
    _percentagePickerTextField.percentages = percentages;
    
    self.svc = [ScanBLEViewController shareSvc];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self.svc.peripheralsArray count] > 0) {
        for (CBPeripheral *peripheral in self.svc.peripheralsArray) {
            if (peripheral.state == CBPeripheralStateConnected) {
                self.peripheral = peripheral;
                NSLog(@"Peripheral is: %@",self.peripheral); // nslog debug message
                break;
            }
        }
    }
    if (!self.peripheral) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"No peripheral connected to the app!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *popBack = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:popBack];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) done {
    
    //self.drugPickerTextField.text = [self.chambers objectAtIndex:[self.drugPickerTextField.picker selectedRowInComponent:0]];;
}

-(void) hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void)hideKeyboard {
    
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.drugPickerTextField) {
        
        self.drugPickerTextField.text = _drugPickerTextField.selectedObject;
        self.drug = self.drugPickerTextField.text;
    }
    else if (textField == self.percentagePickerTextField) {
        
        self.percentagePickerTextField.text =_percentagePickerTextField.selectedObject;
        self.percentage = [self.percentagePickerTextField.text integerValue];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - Send BLE command to Deliver Drug

- (IBAction)didPressDeliverDrug:(id)sender {
    
    if (![self.drug length] || !self.percentage) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Drug Delivery Failed" message:@"Please select both drug and percentage to proceed" preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([self.drug length] && self.percentage) {
        //user has determined both parameters and is ready to deliver the drug
        //implement BLE transmission
        NSString *message = [NSString stringWithFormat:@"%@, %ld %%", self.drug, self.percentage];
        NSLog(@"%@",message);
        NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
        CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
        [self.peripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
        //test
    }
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
