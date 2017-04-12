//
//  SetupWRCDeviceTableViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 10/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanBLEViewController.h"


@interface SetupWRCDeviceTableViewController : UITableViewController

@property (strong, nonatomic) ScanBLEViewController *svc;
@property (strong, nonatomic) NSString *patientName;

@property (strong, nonatomic) NSString *firstChamber;
@property (strong, nonatomic) NSString *secondChamber;
@property (strong, nonatomic) NSString *thirdChamber;

@property NSInteger numberOfDrugs;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *deliverDrugButton;


+(SetupWRCDeviceTableViewController *)sharedInstance;

@end
