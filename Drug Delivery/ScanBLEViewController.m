//
//  ScanBLEViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "ScanBLEViewController.h"
#import "DevicesTableViewController.h"
#import "DataExchangeViewController.h"

//#import "DevicesTableViewController.h"

@interface ScanBLEViewController ()

@end

@implementation ScanBLEViewController

static ScanBLEViewController *_shareSvc;

+(ScanBLEViewController *)shareSvc {
    
    if (!_shareSvc) {
        //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //_shareSvc = [storyBoard instantiateViewControllerWithIdentifier:@"scanVC"];
        _shareSvc = [[ScanBLEViewController alloc] init];
    }
    return _shareSvc;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.indicator.hidden = YES;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerOptionShowPowerAlertKey, nil];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    self.peripheralsArray = [NSMutableArray array];
    // message is printed only once
    NSLog(@"The ScanBLEViewController view Did load!, central %@ initialised",self.centralManager);
    
    if (!_shareSvc) {
        _shareSvc = self;
    }
    // peripheral 1 identifier: 5E357913-7FEC-436D-9ED3-4E8134D1DC4B
    // peripheral 2 identifier: 55B57661-ADC0-4070-8AB1-77AF16F0EA6F
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Memory issue!");
}

-(void)viewWillAppear:(BOOL)animated {
    //can use it for updates, remove objects, modifications etc. Could be useful!
    [super viewWillAppear:animated];
    NSLog(@"View Will Appear");
    
    if (![self.peripheralsArray count]) {
        self.devicesButton.enabled = NO;
    } else {
        self.devicesButton.enabled = YES;
    }
    self.countDetections = NO; //Bool used in order not to push the VC more than once
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (![self.centralManager isScanning]) {
        if ([self.indicator isAnimating]) {
            [self.indicator stopAnimating];
        }
        self.indicator.hidden = YES;
    }
}

#pragma mark - IBActions

- (IBAction)didPressScanButton:(id)sender {
    
    // Check if central is connected to any peripherals
    NSInteger connections = 0; // number of connected devices
    for (CBPeripheral *peripheral in self.peripheralsArray) {
        if (peripheral.state == CBPeripheralStateConnected) {
            connections++;
        }
    }
    NSLog(@"Number of connected devices: %ld",connections);
    if (connections > 0) {
        UIAlertController *alertControllerForScan = [UIAlertController alertControllerWithTitle:@"Scan message" message:@"Scan will cause already connected devices to disconnect" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            for (CBPeripheral *peripheral in self.peripheralsArray) {
                // check which peripheral is connected and cancel connection
                if (peripheral.state == CBPeripheralStateConnected) {
                    [self.centralManager cancelPeripheralConnection:peripheral];
                }
            }
            [self setupScan];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return;
        }];
        [alertControllerForScan addAction:okAction];
        [alertControllerForScan addAction:cancelAction];
        [self presentViewController:alertControllerForScan animated:YES completion:nil];
    }
    else {
        [self setupScan];
    }
}

- (IBAction)didPressLogout:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log out" message:@"Are you sure you want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"login NC"];
        [self presentViewController:viewController animated:YES completion:nil];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - CBCentralDelegate methods

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
    self.peripheral = peripheral;
    self.connectedPeripheral = peripheral;
    // [self.peripheralsArray replaceObjectAtIndex:0 withObject:self.peripheral];
    [peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"Failed to connect to peripheral!");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fail" message:@"Failed to connect to peripheral. Please try again" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Entered didDiscoverPeripheral");
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    NSString *peripheralName = peripheral.name;
    
    if ([localName length] > 0 || [peripheralName length] > 0) {
        NSLog(@"Found device with Local name: %@, Peripheral name: %@", localName, peripheralName);
        // [self.centralManager stopScan];
        [peripheral setDelegate:self];
        self.peripheral = peripheral;
        /*int counter = 0; // start by count = 0
         if ([self.peripheralsArray count] > 0) { // ensure that device has not been detected or displayed more than once
         for (int i = 0; i < [self.peripheralsArray count]; i++) { //loop through the elements of the array and check if the peripheral is equal to any of the peripherals in the array
         if (peripheral.name == [[self.peripheralsArray objectAtIndex:i] name]) {
         counter++;// if ther peripheral is equal to any of the objects than count increases
         }
         if (counter == 0) {// only if count remains zero the peripheral will be added to the array
         [self.peripheralsArray addObject:peripheral];
         }
         }
         } else {
         [self.peripheralsArray addObject:peripheral];// if array is empty than just add an object
         }*/
        if ([self.peripheralsArray containsObject:peripheral]) {
            // don't add it
        } else {
            [self.peripheralsArray addObject:peripheral];
            NSLog(@"peripheral identifier: %@",peripheral.identifier);
        }
        NSLog(@"Number of elements in array %ld",[self.peripheralsArray count]);
        self.connectivityTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkConnectivity) userInfo:nil repeats:YES]; //check if connection is established
    }
    if (!self.countDetections) {
        self.detectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(devicesFoundStopScan) userInfo:nil repeats:NO];//find all the possible devices and stop scan to save power
    }
    self.countDetections = YES;
}


-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    self.connectedPeripheral = nil;
    self.peripheralNameDisplay = nil;
    NSLog(@"Peripheral disconnected");
}

#pragma mark - CBPeripheralDelegate methods

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
        self.bleService = service;
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    NSLog(@"Entered didDiscoverCharacteristics");
    if ([service.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]])  {  // 1
        int i = 0;
        for (CBCharacteristic *aChar in service.characteristics)
        {
            //if ([aChar.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]]) { // 2
            [peripheral setNotifyValue:YES forCharacteristic:aChar];
            NSLog(@"%d Discovered characteristic %@",i,aChar);
            i++;
            //}
        }
        CBCharacteristic *readChar = [self.bleService.characteristics lastObject];//objectAtIndex:1
        [self.peripheral setNotifyValue:YES forCharacteristic:readChar];
    }
    // Retrieve Device Information Services for the Manufacturer Name
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"Did eneter didUpdateValueForCharacteristic!");
    
    if ([characteristic isEqual:[self.bleService.characteristics objectAtIndex:1]]) {
        NSData *rxData = characteristic.value;
        self.rxString = [[NSString alloc] initWithData:rxData encoding:NSUTF8StringEncoding];
        NSLog(@"data received: %@",_rxString);
        DataExchangeViewController *devc = [DataExchangeViewController shareDevc];
        NSLog(@"%@",devc.rxLabel.text);
        devc.rxLabel.text = _rxString;
        
        NSString *firstChar = [self.rxString substringToIndex:1];
        
        if ([firstChar isEqualToString:@"?"]) {
            self.confirmDrugDelivery = self.rxString;
        }
        else if ([firstChar isEqualToString:@"d"]) {
            self.drugsRemaining = self.rxString;
        }
        else if ([firstChar isEqualToString:@"t"]) {
            self.temperature = self.rxString;
        }
    }
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


#pragma mark - void functions to support and organise the program

-(void)setupScan {
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    [self.connectivityTimer invalidate];
    self.connectivityTimer = nil;
    [self.detectTimer invalidate];
    self.detectTimer = nil;
    //[self.peripheralsArray removeAllObjects];
    
    //[_centralManager setDelegate:self];
    if ([self.centralManager isScanning]) {
        NSLog(@"Scan Started (:");
    }
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    [self.peripheralsArray removeAllObjects];
    NSArray *services = [NSArray arrayWithObject:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]];
    [self.centralManager scanForPeripheralsWithServices:services options:nil];
    
    self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scanStopped) userInfo:nil repeats:NO];
}

-(void)didPressConnectButtonInCell {
    
    [_centralManager connectPeripheral:self.peripheral options:nil];
}

- (void)scanStopped
{
    [_centralManager stopScan];
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"BLE Not Found" message:@"No BLE Device has been detected!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:okAction];
    [self presentViewController:controller animated:YES completion:nil];
    
    if (![self.peripheralsArray count]) {
        self.devicesButton.enabled = NO;
    } else {
        self.devicesButton.enabled = YES;
    }
}

- (void)devicesFoundStopScan { // stop scan function after devices have been discovered
    
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    [_centralManager stopScan];
    NSLog(@"Devices have been found, scan has stopped!");
    self.devicesButton.enabled = YES;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DevicesTableViewController *dtvc = [storyBoard instantiateViewControllerWithIdentifier:@"devices tableView"];
    [self.navigationController pushViewController:dtvc animated:YES];
}

-(void)checkConnectivity {
    
    if (_peripheral.state == CBPeripheralStateConnecting) {
        NSLog(@"Connecting!");
    }
    else if (_peripheral.state == CBPeripheralStateConnected) {
        NSLog(@"Connected!");
    }
    else if (_peripheral.state == CBPeripheralStateDisconnecting) {
        NSLog(@"Disconnecting!");
    }
    else if (_peripheral.state == CBPeripheralStateDisconnected) {
        NSLog(@"Disconnected!");
    }
}

@end
