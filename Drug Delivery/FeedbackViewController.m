//
//  FeedbackViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 18/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SetupWRCViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.svc = [ScanBLEViewController shareSvc];
    // Do any additional setup after loading the views
    
    //[self formatViews];
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.drugOneLabel.text = nil;
    self.drugTwoLabel.text = nil;
    self.drugThreeLabel.text = nil;
    self.percentageOneLabel.text = nil;
    self.percentageTwoLabel.text = nil;
    self.percentageThreeLabel.text = nil;
    self.temperatureLabel.text = nil;
    self.deviceLabel.text = nil;
    
    if (self.svc.connectedPeripheral) {
        
        SetupWRCViewController *setupVC = [SetupWRCViewController shareSetupVC];
        self.drugOneLabel.text = [setupVC.chambers objectAtIndex:0];
        self.drugTwoLabel.text = [setupVC.chambers objectAtIndex:1];
        self.drugThreeLabel.text = [setupVC.chambers objectAtIndex:2];

         self.feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getFeedbackFromWRC) userInfo:nil repeats:YES];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"No devices connected" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.tabBarController.selectedIndex = 0;
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.feedbackTimer invalidate];
    self.feedbackTimer = nil;
}

-(void)getFeedbackFromWRC {
    
    self.feedback = self.svc.rxString;
    NSString *drugsRem = [self.svc.drugsRemaining substringToIndex:4];
    self.drugsRemaining = [drugsRem substringFromIndex:1];
    self.temperature = [self.svc.temperature substringFromIndex:1];
    self.tempThreshold = [self.svc.tempThreshold substringToIndex:2];
    self.success = self.svc.success;
    NSLog(@"feedback is: %@ Temp: %@, DrugsRem: %@, threshold :%@",self.feedback,self.temperature,self.drugsRemaining,self.tempThreshold);
    
    self.message = @"t";
    self.peripheral = self.svc.connectedPeripheral;
    NSData *data = [NSData dataWithBytes:[_message UTF8String] length:[_message length]];
    CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
    [self.peripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
    
    self.message = @"d";
    data = [NSData dataWithBytes:[_message UTF8String] length:[_message length]];
    [self.peripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
    
    self.message = @"h";
    data = [NSData dataWithBytes:[_message UTF8String] length:[_message length]];
    [self.peripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
    
    [self setupValuesForViews];
    [self formatViews];
}

-(void) setupValuesForViews {
    
    char drugOne = [self.drugsRemaining characterAtIndex:0];
    char drugTwo = [self.drugsRemaining characterAtIndex:1];
    char drugThree = [self.drugsRemaining characterAtIndex:2];
    
    if (drugOne == '1') {
        self.drugOneQuantity = 25;
    }
    else if (drugOne == '2') {
        self.drugOneQuantity = 50;
    }
    else if (drugOne == '3') {
        self.drugOneQuantity = 75;
    }
    else if (drugOne == '4') {
        self.drugOneQuantity = 100;
    } else {
        self.drugOneQuantity = 0;
    }
    
    if (drugTwo == '1') {
        self.drugTwoQuantity = 25;
    }
    else if (drugTwo == '2') {
        self.drugTwoQuantity = 50;
    }
    else if (drugTwo == '3') {
        self.drugTwoQuantity = 75;
    }
    else if (drugTwo == '4') {
        self.drugTwoQuantity = 100;
    } else {
        self.drugTwoQuantity = 0;
    }
    
    if (drugThree == '1') {
        self.drugThreeQuantity = 25;
    }
    else if (drugThree == '2') {
        self.drugThreeQuantity = 50;
    }
    else if (drugThree == '3') {
        self.drugThreeQuantity = 75;
    }
    else if (drugThree == '4') {
        self.drugThreeQuantity = 100;
    }
    else {
        _drugThreeQuantity = 0;
    }
}

-(void) formatViews {
    
    if (_drugOneQuantity == 0) {
        self.firstViewDrugOne.backgroundColor = [UIColor whiteColor];
        self.secondViewDrugOne.backgroundColor = [UIColor whiteColor];
        self.thirdViewDrugOne.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugOne.backgroundColor = [UIColor whiteColor];
    }
    
    else if (self.drugOneQuantity == 25) {
        
        self.firstViewDrugOne.backgroundColor = [UIColor redColor];
        self.secondViewDrugOne.backgroundColor = [UIColor whiteColor];
        self.thirdViewDrugOne.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugOne.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugOneQuantity == 50) {
        
        self.firstViewDrugOne.backgroundColor = [UIColor orangeColor];
        self.secondViewDrugOne.backgroundColor = [UIColor orangeColor];
        self.thirdViewDrugOne.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugOne.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugOneQuantity == 75) {
        
        self.firstViewDrugOne.backgroundColor = [UIColor greenColor];
        self.secondViewDrugOne.backgroundColor = [UIColor greenColor];
        self.thirdViewDrugOne.backgroundColor = [UIColor greenColor];
        self.fourthViewDrugOne.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugOneQuantity == 100) {
     
        self.firstViewDrugOne.backgroundColor = [UIColor greenColor];
        self.secondViewDrugOne.backgroundColor = [UIColor greenColor];
        self.thirdViewDrugOne.backgroundColor = [UIColor greenColor];
        self.fourthViewDrugOne.backgroundColor = [UIColor greenColor];
    }
    
    if (self.drugTwoQuantity == 0) {
        
        self.firstViewDrugTwo.backgroundColor = [UIColor whiteColor];
        self.secondViewDrugTwo.backgroundColor = [UIColor whiteColor];
        self.thirdViewDrugTwo.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugTwo.backgroundColor = [UIColor whiteColor];
    }
    
    else if (self.drugTwoQuantity == 25) {
        
        self.firstViewDrugTwo.backgroundColor = [UIColor redColor];
        self.secondViewDrugTwo.backgroundColor = [UIColor whiteColor];
        self.thirdViewDrugTwo.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugTwo.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugTwoQuantity == 50) {
        
        self.firstViewDrugTwo.backgroundColor = [UIColor orangeColor];
        self.secondViewDrugTwo.backgroundColor = [UIColor orangeColor];
        self.thirdViewDrugTwo.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugTwo.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugTwoQuantity == 75) {
        
        self.firstViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.secondViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.thirdViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.fourthViewDrugTwo.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugTwoQuantity == 100) {
        
        self.firstViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.secondViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.thirdViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.fourthViewDrugTwo.backgroundColor = [UIColor greenColor];
    }
    
    if (self.drugThreeQuantity == 0) {
        
        self.firstViewDrugThree.backgroundColor = [UIColor whiteColor];
        self.secondViewDrugThree.backgroundColor = [UIColor whiteColor];
        self.thirdViewDrugThree.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugThree.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugThreeQuantity == 25) {
        
        self.firstViewDrugThree.backgroundColor = [UIColor redColor];
        self.secondViewDrugThree.backgroundColor = [UIColor whiteColor];
        self.thirdViewDrugThree.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugThree.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugThreeQuantity == 50) {
        
        self.firstViewDrugThree.backgroundColor = [UIColor orangeColor];
        self.secondViewDrugThree.backgroundColor = [UIColor orangeColor];
        self.thirdViewDrugThree.backgroundColor = [UIColor whiteColor];
        self.fourthViewDrugThree.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugThreeQuantity == 75) {
        
        self.firstViewDrugThree.backgroundColor = [UIColor greenColor];
        self.secondViewDrugThree.backgroundColor = [UIColor greenColor];
        self.thirdViewDrugThree.backgroundColor = [UIColor greenColor];
        self.fourthViewDrugThree.backgroundColor = [UIColor whiteColor];
    }
    else if (self.drugThreeQuantity == 100) {
        self.firstViewDrugThree.backgroundColor = [UIColor greenColor];
        self.secondViewDrugThree.backgroundColor = [UIColor greenColor];
        self.thirdViewDrugThree.backgroundColor = [UIColor greenColor];
        self.fourthViewDrugThree.backgroundColor = [UIColor greenColor];
    }
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"Temperature: %@ C",self.temperature];
    self.deviceLabel.text = [NSString stringWithFormat:@"Device: %@",self.svc.peripheralNameDisplay];
    
    if (self.temperature == nil) {
        self.temperatureLabel.text = @"";
    }
    if (!self.svc.connectedPeripheral) {
        self.deviceLabel.text = @"";
    }
    
    self.percentageOneLabel.text = [NSString stringWithFormat:@"%ld %%",self.drugOneQuantity];
    self.percentageTwoLabel.text = [NSString stringWithFormat:@"%ld %%",self.drugTwoQuantity];
    self.percentageThreeLabel.text = [NSString stringWithFormat:@"%ld %%",self.drugThreeQuantity];
    
    if ([self.tempThreshold isEqualToString:@"h1"]) {
       // _threshold = YES;
        
        /*if (self.svc.connectedPeripheral.state == CBPeripheralStateConnected) {
            [self.feedbackTimer invalidate];
            self.feedbackTimer = nil;
            NSString *message = @"b";
            NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
            CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
            [self.svc.connectedPeripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
            NSLog(@"b message sent to MCR!");
            [self.svc.centralManager cancelPeripheralConnection:self.svc.connectedPeripheral];
        }*/

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Temperature threshold has been exceeded!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *disconnect = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:disconnect];
        [self presentViewController:alert animated:YES completion:nil];
        }
    
    if ([self.success isEqualToString:@"s"]) {
        self.success = nil;
        self.svc.success = nil;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Drug Delivery process has finished" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
