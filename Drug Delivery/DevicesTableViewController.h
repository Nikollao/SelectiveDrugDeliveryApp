//
//  DevicesTableViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScanBLEViewController.h"
#import "BLEDeviceTableViewCell.h"

@interface DevicesTableViewController : UITableViewController <CBPeripheralDelegate, CBCentralManagerDelegate>

@property (strong, nonatomic) BLEDeviceTableViewCell *cell;
@property (strong, nonatomic) NSString *sendString;
@property (strong, nonatomic) ScanBLEViewController *svc;

@end
