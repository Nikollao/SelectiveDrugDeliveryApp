//
//  ScanBLEViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define DEVICE_INFO_SERVICE_UUID @"713D0000-503E-4C75-BA94-3148F18D941E"

//@import CoreBluetooth;
@import QuartzCore; // graphics and animation framework

@interface ScanBLEViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

// NSFoundation
@property (strong, nonatomic) NSMutableArray *peripheralsArray;
//@property (strong, nonatomic) NSMutableArray *bleServices;
//@property (strong, nonatomic) NSMutableArray *bleCharacteristics;

@property (nonatomic) BOOL countDetections;

// Timers
@property (strong, nonatomic) NSTimer *scanTimer;
@property (strong, nonatomic) NSTimer *connectivityTimer;
@property (strong, nonatomic) NSTimer *detectTimer;

// IBoutlets
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UITableViewController *dvc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *devicesButton;


// CB properties
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSString *numberOfDrugs;

@property (strong, nonatomic) CBService *bleService;
@property (strong, nonatomic) CBCharacteristic *bleChar;

// IBactions
- (IBAction)didPressScanButton:(id)sender;

-(void)didPressConnectButtonInCell;

// share vc instance to create global variables
+(ScanBLEViewController *) shareSvc;


@end
