//
//  DrugPickerTextField.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 12/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrugPickerTextField : UITextField <UIKeyInput, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *chambers;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) BOOL showToolBar;
@property (nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSString *selectedObject;

@end
