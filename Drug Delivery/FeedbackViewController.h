//
//  FeedbackViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 18/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanBLEViewController.h"

@interface FeedbackViewController : UIViewController

@property (strong, nonatomic) ScanBLEViewController *svc;
@property (strong, nonatomic) NSString *feedback;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *drugOneViews;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *drugTwoViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *drugThreeViews;



@end
