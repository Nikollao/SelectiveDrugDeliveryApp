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
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Number of elements/rows = %ld",[self.svc.peripheralsArray count]);
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
    NSString *title = peripheral.name;
    NSString *subTitle = nil;
    
    if (peripheral.state == CBPeripheralStateConnected) {
        subTitle = @"Connected: YES";
    }
    else if (peripheral.state == CBPeripheralStateDisconnected) {
        subTitle = @"Connected: NO";
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
    
    if (peripheral.state == CBPeripheralStateConnected) {
        NSLog(@"Central is connected! Table View reload data!");
        [_cell.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    }
    else if (peripheral.state == CBPeripheralStateDisconnected) {
        NSLog(@"Central is Disconnected! Table View reload data!");
        [_cell.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    }
    
    _cell.titleLabel.text = title;
    _cell.subTitleLabel.text = subTitle; // connected button
    _cell.connectButton.tag = indexPath.row;
    return _cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"data segue"]) {
        DataExchangeViewController *dvc = [segue destinationViewController];
        self.sendString = @"Hey";
        dvc.rxString = self.sendString;
    }
}

- (IBAction)didPressConnectButton:(id)sender {
    
    // NSLog(@"Selected Row is: %ld",indexPath.row);
    CBPeripheral *peripheral = [self.svc.peripheralsArray objectAtIndex:self.cell.connectButton.tag];
    NSLog(@"Button tag = %ld",self.cell.connectButton.tag);
    if (peripheral.state == CBPeripheralStateDisconnected) {
        [self.svc.centralManager connectPeripheral:peripheral options:nil];
    }
    else if (peripheral.state == CBPeripheralStateConnected) {
        [self.svc.centralManager cancelPeripheralConnection:peripheral];
    }
    // give sufficient time to the central to connect or disconnect from the peripheral
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(updateTableView) userInfo:nil repeats:NO];
    //_cell.isConnected =! _cell.isConnected;
}

-(void)updateTableView {
    
    [self.tableView reloadData];
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
