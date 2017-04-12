//
//  SetupWRCViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 11/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrugPickerTextField.h"
#import "PercentagePickerTextField.h"

@interface SetupWRCViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *deliverDrug;

@property (strong, nonatomic) IBOutlet DrugPickerTextField *drugPickerTextField;
@property (strong, nonatomic) IBOutlet PercentagePickerTextField *percentagePickerTextField;

@property (strong, nonatomic) NSArray *chambers;
@property (strong, nonatomic) NSString *drug;
@property (nonatomic) NSInteger percentage;

- (IBAction)didPressDeliverDrug:(id)sender;

@end
