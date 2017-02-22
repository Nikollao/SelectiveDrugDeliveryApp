//
//  DevicesTableViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDeviceTableViewCell.h"

@interface DevicesTableViewController : UITableViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) BLEDeviceTableViewCell *cell;

@property (strong, nonatomic) NSString *sendString;

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (strong, nonatomic) NSMutableArray *peripheralsArray;

- (IBAction)didPressConnectButton:(id)sender;

@end
