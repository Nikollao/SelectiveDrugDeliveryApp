//
//  SetupWRCViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 11/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "SetupWRCViewController.h"

@interface SetupWRCViewController ()

@end

@implementation SetupWRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drugPickerTextField.delegate = self;
    self.percentagePickerTextField.delegate = self;
    [self hideKeyboardWhenBackgroundIsTapped];
    _drugPickerTextField.chambers = self.chambers;
    
    NSArray *percentages = [NSArray arrayWithObjects:@"25",@"50",@"75",@"100", nil];
    _percentagePickerTextField.percentages = percentages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) done {
    
    //self.drugPickerTextField.text = [self.chambers objectAtIndex:[self.drugPickerTextField.picker selectedRowInComponent:0]];;
}

-(void) hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void)hideKeyboard {
    
    [self.view endEditing:YES];
}

#pragma mark - TextField Delegate methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.drugPickerTextField) {
        
        self.drugPickerTextField.text = _drugPickerTextField.selectedObject;
        self.drug = self.drugPickerTextField.text;
    }
    else if (textField == self.percentagePickerTextField) {
        
        self.percentagePickerTextField.text =_percentagePickerTextField.selectedObject;
        self.percentage = [self.percentagePickerTextField.text integerValue];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}


- (IBAction)didPressDeliverDrug:(id)sender {
    
    if (![self.drug length] || !self.percentage) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Drug Delivery Failed" message:@"Please select both drug and percentage to proceed" preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
