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
     [self.tableView reloadData];
     // when the devices button is pressed, the tableview does not appear in the state which was left
    // the button from disconnect becomes connect!
    // need to find a way to remember that there is a connection established when i open the devices through devices
    // possible solution don;t use devices button (:
    [self updateTableView];
}

#pragma mark - TableView Data Source methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.peripheralsArray count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    
     NSString *header = @"WRC Devices";
    
    return header;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"device cell";
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    CBPeripheral *peripheral = [self.peripheralsArray objectAtIndex:indexPath.row];
    // NSString *title = [[self.peripheralsArray objectAtIndex:indexPath.row] name];
    NSString *title = peripheral.name;
    NSString *subTitle = nil;
    
    if (peripheral.state == CBPeripheralStateConnected) {
        subTitle = @"Connected: YES";
    }
    else if (peripheral.state == CBPeripheralStateDisconnected) {
        subTitle = @"Connected: NO";
    } else {
        subTitle = @"Unknown State";
    }
    
    _cell.titleLabel.text = title;
    _cell.subTitleLabel.text = subTitle; // connected button
    
    return _cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"data segue"]) {
        DataExchangeViewController *dvc = [segue destinationViewController];
        self.sendString = @"Hey";
        dvc.rxString = self.sendString;
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
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


- (IBAction)didPressConnectButton:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CBPeripheral *peripheral = [self.peripheralsArray objectAtIndex:indexPath.row];

    if (!_cell.isConnected) {
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    else if (_cell.isConnected) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    // give sufficient time to the central to connect or disconnect from the peripheral
    [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(updateTableView) userInfo:nil repeats:NO];
    _cell.isConnected =! _cell.isConnected;
}

-(void) updateTableView { // updata the tableView the labels and the button
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CBPeripheral *peripheral = [self.peripheralsArray objectAtIndex:indexPath.row];

    if (peripheral.state == CBPeripheralStateConnected) {
        NSLog(@"Central is connected! Table View reload data!");
        [_cell.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
    else if (peripheral.state == CBPeripheralStateDisconnected) {
        NSLog(@"Central is Disconnected! Table View reload data!");
        [_cell.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
    // [self.peripheralsArray replaceObjectAtIndex:indexPath.row withObject:peripheral];
}

@end
