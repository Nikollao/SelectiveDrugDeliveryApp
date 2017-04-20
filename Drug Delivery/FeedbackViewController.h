//
//  FeedbackViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 18/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanBLEViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface FeedbackViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) ScanBLEViewController *svc;
@property (strong, nonatomic) NSString *feedback;

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSString *message;

// parameters
@property NSInteger drugOneQuantity;
@property NSInteger drugTwoQuantity;
@property NSInteger drugThreeQuantity;
@property float temperatureFloat;
@property BOOL threshold;

@property (strong, nonatomic) NSTimer *feedbackTimer;
@property (strong, nonatomic) NSString *temperature;
@property (strong, nonatomic) NSString *drugsRemaining;
@property (strong, nonatomic) NSString *tempThreshold;

// views
// first drug
@property (strong, nonatomic) IBOutlet UIView *firstViewDrugOne;
@property (strong, nonatomic) IBOutlet UIView *secondViewDrugOne;
@property (strong, nonatomic) IBOutlet UIView *thirdViewDrugOne;
@property (strong, nonatomic) IBOutlet UIView *fourthViewDrugOne;

// second drug
@property (strong, nonatomic) IBOutlet UIView *firstViewDrugTwo;
@property (strong, nonatomic) IBOutlet UIView *secondViewDrugTwo;
@property (strong, nonatomic) IBOutlet UIView *thirdViewDrugTwo;
@property (strong, nonatomic) IBOutlet UIView *fourthViewDrugTwo;

// third drug
@property (strong, nonatomic) IBOutlet UIView *firstViewDrugThree;
@property (strong, nonatomic) IBOutlet UIView *secondViewDrugThree;
@property (strong, nonatomic) IBOutlet UIView *thirdViewDrugThree;
@property (strong, nonatomic) IBOutlet UIView *fourthViewDrugThree;

// Labels
@property (strong, nonatomic) IBOutlet UILabel *percentageOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentageTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentageThreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *drugOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *drugTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *drugThreeLabel;


@property (strong, nonatomic) IBOutlet UILabel *deviceLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;

// device


@end
