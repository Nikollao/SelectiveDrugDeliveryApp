//
//  DrugPickerTextField.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 12/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "DrugPickerTextField.h"

@implementation DrugPickerTextField

-(void) pickerDelegate {
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.chambers count];
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 44.0f;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 280.0f;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.chambers objectAtIndex:row];
}

#pragma mark - Interact

- (void)done{
    
    self.selectedRow = [self.picker selectedRowInComponent:0];
    self.selectedObject = [self.chambers objectAtIndex:[self.picker selectedRowInComponent:0]];
    [self endEditing:YES];
    [self resignFirstResponder];
}

-(void)clear{
    
    [self resignFirstResponder];
}


#pragma mark - View

-(UIView *) createInputView {
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.picker.showsSelectionIndicator = YES;
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.picker sizeToFit];
    return self.picker;
}

-(UIView *) createInputAccessoryView {
    
    self.showToolBar = YES;
    
    if (!_toolbar && _showToolBar) {
        
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.toolbar sizeToFit];
        
        CGRect frame = self.toolbar.frame;
        frame.size.height = 44.0f;
        //frame.size.width = 44.0f;
        self.toolbar.frame = frame;
        
        UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:clearBtn,spacer,doneBtn, nil];
        
        [self.toolbar setItems:array];
    }
    return self.toolbar;
}

-(id) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.inputView = [self createInputView];
        self.inputAccessoryView = [self createInputAccessoryView];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        self.inputView = [self createInputView];
        self.inputAccessoryView = [self createInputAccessoryView];
    }
    return self;
}

-(id) init {
    
    self = [super init];
    if (self) {
        [self pickerDelegate];
    }
    return self;
}

@end
