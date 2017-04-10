//
//  AssignPatientTableViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 10/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "SetupWRCDeviceTableViewController.h"

@interface AssignPatientTableViewController : CoreDataTableViewController

@property (strong, nonatomic) SetupWRCDeviceTableViewController *stvc;

@end
