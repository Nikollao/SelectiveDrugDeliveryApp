//
//  ScanBLEViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "ScanBLEViewController.h"
#import "DevicesTableViewController.h"

@interface ScanBLEViewController ()

@end

@implementation ScanBLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicator.hidden = YES;
    self.peripheralsArray = [NSMutableArray array];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.disconnectButton.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self.indicator isAnimating]) {
        [self.indicator stopAnimating];
    }
    self.indicator.hidden = YES;
}

- (IBAction)didPressScanButton:(id)sender {
    
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    // NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey, nil];

    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scanStopped) userInfo:nil repeats:NO];
    NSArray *services = [NSArray arrayWithObject:
                         [CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]];
    
    [_centralManager scanForPeripheralsWithServices:services options:nil];
    if ([_centralManager isScanning]) {
        NSLog(@"Scan Started (:");
    }

}

- (IBAction)didPressDisconnectButton:(id)sender {
 
    if (self.peripheral.state == CBPeripheralStateConnected) {
        
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        self.disconnectButton.enabled = NO;
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Disconnect" message:@"You have been disconnected from the device!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:okAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
    self.connected = [NSString stringWithFormat:@"Connected: %@", _peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
        NSLog(@"Connected? %@", self.connected);
    [self.peripheralsArray removeObject:[self.peripheralsArray firstObject]];
}
- (void)scanStopped
{
    [self.centralManager stopScan];
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"BLE Not Found" message:@"No BLE Device has been detected!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:okAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
        self.scanButton.enabled = NO;
    }
    else if ([central state] == CBManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        self.scanButton.enabled = YES;
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

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"Entered didConnectPeripheral");
    
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
    self.disconnectButton.enabled = YES;
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Failed to connect to peripheral!");
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Entered didDiscoverPeripheral");
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    localName = peripheral.name;
    
    if ([localName length] > 0) {
        
        NSLog(@"Found one device: %@", localName);
        [self.centralManager stopScan];
        peripheral.delegate = self;
         self.peripheral = peripheral;
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"BLE Found" message:[NSString stringWithFormat:@"The %@ BLE device has been found",peripheral.name] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *connectAction = [UIAlertAction actionWithTitle:@"Connect" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [_peripheralsArray addObject:peripheral];
            [central connectPeripheral:[self.peripheralsArray objectAtIndex:0] options:nil];
            self.connectivityTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkConnectivity) userInfo:nil repeats:YES];
        }];
        [controller addAction:cancelAction];
        [controller addAction:connectAction];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)checkConnectivity {
    
    if (self.peripheral.state == CBPeripheralStateConnecting) {
        NSLog(@"Connecting!");
    }
    else if (self.peripheral.state == CBPeripheralStateConnected) {
        NSLog(@"Connected!");
    }
    else if (self.peripheral.state == CBPeripheralStateDisconnecting) {
        NSLog(@"Disconnecting!");
    }
    else if (self.peripheral.state == CBPeripheralStateDisconnected) {
        NSLog(@"Disconnected!");
    }
}

#pragma mark - CBPeripheralDelegate

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    NSLog(@"Entered didDiscoverCharacteristics");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]])  {  // 1
        int i = 0;
        for (CBCharacteristic *aChar in service.characteristics)
        {
            //if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]]) { // 2
            [self.peripheral setNotifyValue:YES forCharacteristic:aChar];
            NSLog(@"%d Discovered characteristic %@",i,aChar);
            i++;
            //}
        }
    }
    // Retrieve Device Information Services for the Manufacturer Name
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"Did eneter didUpdateValueForCharacteristic!");
    /*
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_REMAINING_DRUG_CHARACTERISTIC_UUID]]) { // 1
        // Get the Heart Rate Monitor BPM
        //[self getHeartBPMData:characteristic error:error];
    }
    // Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {  // 2
        [self getManufacturerName:characteristic];
    }
    // Retrieve the characteristic value for the body sensor location received
     else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) {  // 3
     [self getBodyLocation:characteristic];
     }*/
    
    // Add your constructed device information to your UITextView */
}

-(void)getManufacturerName:(CBCharacteristic *)characteristic {
    /*
    NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];  // 1
    self.manufacturer = [NSString stringWithFormat:@"Manufacturer: %@", manufacturerName];    // 2
    return;*/
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DevicesTableViewController *dtvc = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"device cell"]) {
        
        dtvc.peripheralsArray = _peripheralsArray;
    }
}

@end
