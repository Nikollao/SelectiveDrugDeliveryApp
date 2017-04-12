//
//  CoreDataPickerTextField.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@class CoreDataPickerTextField;

@protocol CoreDataPickerTextFieldDelegate <NSObject>

-(void)selectedObjectID: (NSManagedObjectID *)objectID changedForPickerTextField: (CoreDataPickerTextField *)pickerTextField;

@optional

-(void)selectedobjectClearedForPickerTextField: (CoreDataPickerTextField *) pickerTextField;

@end

@interface CoreDataPickerTextField : UITextField <UIKeyInput, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) id <CoreDataPickerTextFieldDelegate> pickerDelegate;

@property (nonatomic, strong) NSArray *pickerData;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic) BOOL showToolBar;
@property (nonatomic, strong) NSManagedObjectID *selectedObjectID;

@end
