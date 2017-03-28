//
//  DataExchangeViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 26/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScanBLEViewController.h"

#define kOFFSET_FOR_KEYBOARD 110.0

@interface DataExchangeViewController : UIViewController <UITextFieldDelegate, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) ScanBLEViewController *svc;

@property (strong, nonatomic) CBPeripheral *peripheral;

@property (weak, nonatomic) IBOutlet UILabel *rxLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSString *rxString;

- (IBAction)didPressSendButton:(id)sender;

+(DataExchangeViewController *) shareDevc;

@end
