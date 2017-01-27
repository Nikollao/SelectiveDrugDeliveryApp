//
//  CoreDataPickerTextField.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "CoreDataPickerTextField.h"

@implementation CoreDataPickerTextField

#pragma mark - DELEGATE & DATASOURCE

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.pickerData count];
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 44.0f;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 280.0f;
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.pickerData objectAtIndex:row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    NSManagedObject *object = [self.pickerData objectAtIndex:row];
    [self.pickerDelegate selectedObjectID:object.objectID changedForPickerTextField:self];
}

#pragma mark - Interact

- (void)done{
    
    [self resignFirstResponder];
}

-(void)clear{
    
    [self.pickerDelegate selectedobjectClearedForPickerTextField:self];
    [self resignFirstResponder];
}

-(void) fetch {
    
    [NSException raise:NSInternalInconsistencyException format:@"You must override the '%@' method to provide data to the picker",NSStringFromSelector(_cmd)];// it raises an exception if we don't override the method
}

-(void)selectDefaultRow {
    
    [NSException raise:NSInternalInconsistencyException format:@"You must ovveride the '%@' method to set the default picker row",NSStringFromSelector(_cmd)];
}

#pragma mark - View

-(UIView *) createInputView {
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.picker.showsSelectionIndicator = YES;
    self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.picker sizeToFit];
    [self fetch];
    //[self selectDefaultRow];
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


@end
