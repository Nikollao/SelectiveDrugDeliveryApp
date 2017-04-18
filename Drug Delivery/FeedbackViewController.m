//
//  FeedbackViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 18/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.svc = [ScanBLEViewController shareSvc];
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getFeedbackFromWRC) userInfo:nil repeats:YES];
    
    //[self formatViews];
}

-(void) formatViews {
    
    if (self.drugOneQuantity == 25) {
        
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
    
    if (self.drugTwoQuantity == 25) {
        
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
        self.secondViewDrugTwo.backgroundColor = [UIColor greenColor];
        self.secondViewDrugTwo.backgroundColor = [UIColor greenColor];
    }
    
    if (self.drugThreeQuantity == 25) {
        
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
}

-(void)getFeedbackFromWRC {
    
    self.feedback = self.svc.rxString;
    NSLog(@"feedback is: %@",self.feedback);
    self.drugOneQuantity = 25;
    self.drugTwoQuantity = 50;
    self.drugThreeQuantity = 100;
    self.temperature = 25;
    //self.connectedPeripheral = ;
    
    [self formatViews];
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

@end
