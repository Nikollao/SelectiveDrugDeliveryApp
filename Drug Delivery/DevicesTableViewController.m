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
    // [self.tableView reloadData];
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSString *title = [[self.peripheralsArray objectAtIndex:indexPath.row] name];
    NSString *subTitle = [[NSString alloc] init];
    
    CBPeripheral *peripheral = [self.peripheralsArray objectAtIndex:indexPath.row];
    
    if (peripheral.state == CBPeripheralStateConnected) {
        subTitle = @"Connected: YES";
    }
    else if (peripheral.state == CBPeripheralStateDisconnected) {
        subTitle = @"Connected: NO";
    } else {
        subTitle = @"Unknown State";
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle; // connected button
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"send segue"]) {
        DataExchangeViewController *dvc = [segue destinationViewController];
        self.sendString = @"Hey";
        dvc.rxString = self.sendString;
    }
}

#pragma mark - CBCentralManagerDelegate


@end
