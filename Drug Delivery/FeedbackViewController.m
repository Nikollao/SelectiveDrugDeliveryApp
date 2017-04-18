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
    
    [self formatViews];
}

-(void) formatViews {
    
    for (UIView *view in self.drugOneViews) {
        view.backgroundColor = [UIColor greenColor];
    }
    
    for (UIView *view in self.drugTwoViews) {
        view.backgroundColor = [UIColor greenColor];
    }
    for (UIView *view in self.drugThreeViews) {
        view.backgroundColor = [UIColor greenColor];
    }
}

-(void)getFeedbackFromWRC {
    
    self.feedback = self.svc.rxString;
    NSLog(@"feedback is: %@",self.feedback);
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
