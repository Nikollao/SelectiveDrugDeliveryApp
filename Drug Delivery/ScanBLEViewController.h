//
//  ScanBLEViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define DEVICE_INFO_SERVICE_UUID @"713D0000-503E-4C75-BA94-3148F18D941E"

//@import CoreBluetooth;
@import QuartzCore;

@interface ScanBLEViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) NSMutableArray *peripheralsArray;

@property (strong, nonatomic) NSTimer *scanTimer;
@property (strong, nonatomic) NSTimer *connectivityTimer;

@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) CBCentralManager *centralManager;
// @property (strong, nonatomic) CBPeripheral *peripheral;

@property (strong, nonatomic) NSString *numberOfDrugs;

- (IBAction)didPressScanButton:(id)sender;
- (IBAction)didPressDisconnectButton:(id)sender;

/*
- (void) centralManagerDidUpdateState:(CBCentralManager *)central;
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals;
- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals;
*/

@end
