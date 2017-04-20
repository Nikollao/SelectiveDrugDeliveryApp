//
//  DevicesTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "DevicesTableViewController.h"
#import "DataExchangeViewController.h"
@interface DevicesTableViewController ()

@end

@implementation DevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // when the devices button is pressed, the tableview does not appear in the state which was left
    // the button from disconnect becomes connect!
    // need to find a way to remember that there is a connection established when i open the devices through devices
    // possible solution don't use devices button (:
    //[self updateTableView];
    self.svc = [ScanBLEViewController shareSvc];
    NSLog(@"Number of elements in array %ld",[self.svc.peripheralsArray count]);
    //self.dataButton.enabled = NO;
    self.deviceConnectedTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(deviceConnected) userInfo:nil repeats:YES];
    
    // peripheral 1 identifier: 5E357913-7FEC-436D-9ED3-4E8134D1DC4B
    // peripheral 2 identifier: 55B57661-ADC0-4070-8AB1-77AF16F0EA6F
    // peripheral 3 identifier: 38D76015-A3DD-4547-B2EA-B9D1D6B3D080

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    if ([self.svc.peripheralsArray count]>0) {
        for (CBPeripheral *peripheral in self.svc.peripheralsArray) {
            
            if (peripheral.state == CBPeripheralStateConnected) {
                self.peripheral = peripheral;
                self.dataButton.enabled = YES;
            }
            else {
                self.dataButton.enabled = NO;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"Number of elements/rows = %ld",[self.svc.peripheralsArray count]);
    return [self.svc.peripheralsArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    
     NSString *header = @"WRC Devices";
    
    return header;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"device cell";
    _cell = [[BLEDeviceTableViewCell alloc] init];
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CBPeripheral *peripheral = [self.svc.peripheralsArray objectAtIndex:indexPath.row];
    // NSString *title = [[self.peripheralsArray objectAtIndex:indexPath.row] name];
    
    NSString *titleCell = [[NSString alloc] init];
    NSString *subTitle = [[NSString alloc] init];
    NSString *idPeripheral = [peripheral.identifier UUIDString];
    NSLog(@"peripheral id: %@",idPeripheral);
    
    if ([idPeripheral isEqualToString:@"5E357913-7FEC-436D-9ED3-4E8134D1DC4B"]) {
        titleCell = @"MCR Prototype 1";
    }
    else if ([idPeripheral isEqualToString:@"55B57661-ADC0-4070-8AB1-77AF16F0EA6F"]) {
         titleCell = @"MCR Prototype iOS";
    }
    else if ([idPeripheral isEqualToString:@"38D76015-A3DD-4547-B2EA-B9D1D6B3D080"]) {
        titleCell = @"MCR Prototype 2";
    }
    
    if (peripheral.state == CBPeripheralStateConnected) {
        subTitle = @"Connected: YES";
        //_svc.connectedPeripheral = peripheral;
    }
    else if (peripheral.state == CBPeripheralStateDisconnected) {
        subTitle = @"Connected: NO";
        //_svc.connectedPeripheral = nil;
    }
    else if (peripheral.state == CBPeripheralStateConnecting) {
        subTitle = @"Connecting...";
    }
    else if (peripheral.state == CBPeripheralStateDisconnecting) {
        subTitle = @"Disconnecting...";
    }
    else {
        subTitle = @"Don't know!";
    }
    _cell.titleLabel.text = titleCell;
    _cell.subTitleLabel.text = subTitle; // connected button
    return _cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBPeripheral *peripheral = [self.svc.peripheralsArray objectAtIndex:indexPath.row];
    if (peripheral.state == CBPeripheralStateDisconnected) {
        
        if (self.svc.connectedPeripheral) {
            [self.svc.centralManager cancelPeripheralConnection:self.svc.connectedPeripheral];
        }
        [self.svc.centralManager connectPeripheral:peripheral options:nil];
        self.svc.connectedPeripheral = peripheral;
        self.peripheral = peripheral;
    }
    else if (peripheral.state == CBPeripheralStateConnected) {
        [self.svc.centralManager cancelPeripheralConnection:peripheral];
        self.svc.connectedPeripheral = nil;
    }
    // give sufficient time to the central to connect or disconnect from the peripheral
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTableView) userInfo:nil repeats:NO];
}

-(void)updateTableView {
    
    [self.tableView reloadData];
    
    NSString *message = [[NSString alloc] init];
    if (self.svc.connectedPeripheral) {
        message = @"c";
        NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
        CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
        [self.peripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
       
        NSString *displayName = [[NSString alloc] init];
        NSString *idPeripheral = [self.svc.connectedPeripheral.identifier UUIDString];
        NSLog(@"peripheral id: %@",idPeripheral);
        
        if ([idPeripheral isEqualToString:@"5E357913-7FEC-436D-9ED3-4E8134D1DC4B"]) {
            displayName = @"MCR Prototype 1";
        }
        else if ([idPeripheral isEqualToString:@"55B57661-ADC0-4070-8AB1-77AF16F0EA6F"]) {
            displayName = @"MCR Prototype iOS";
        }
        else if ([idPeripheral isEqualToString:@"38D76015-A3DD-4547-B2EA-B9D1D6B3D080"]) {
            displayName = @"MCR Prototype 2";
        }
        self.svc.peripheralNameDisplay = displayName;
    }
    else if (!self.svc.connectedPeripheral) {
        self.svc.peripheralNameDisplay = nil;
        message = @"d";
        NSLog(@"message: %@",message);
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

#pragma mark - Timer enables or disables the dataButton

-(void)deviceConnected {
    
    if ([self.svc.peripheralsArray count] > 0) {
        NSInteger countConnections = 0;
        
        for (CBPeripheral *peripheral in self.svc.peripheralsArray) {
            
            if (peripheral.state == CBPeripheralStateConnected) {
                countConnections++;
            }
        }
        if (countConnections == 1) {
            self.dataButton.enabled = YES;
        }
        else {
            self.dataButton.enabled = NO;
        }
    }
    //[self.tableView reloadData];
}

@end
