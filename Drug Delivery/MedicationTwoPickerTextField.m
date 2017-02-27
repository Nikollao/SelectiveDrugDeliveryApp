//
//  MedicationTwoPickerTextField.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 24/02/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "MedicationTwoPickerTextField.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Medication.h"


@implementation MedicationTwoPickerTextField

-(void) fetch{
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Medication"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:15]; // very good practice to make the fetch more efficient
    self.pickerData = [cdh.context executeFetchRequest:request error:nil];
    [self selectDefaultRow];
}

-(void)selectDefaultRow {
    
    if (self.selectedObjectID && [self.pickerData count] > 0) {
        
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Medication *selectedObject = (Medication *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        [self.pickerData enumerateObjectsUsingBlock:^(Medication *medication, NSUInteger idx, BOOL *stop) {
            
            if ([medication.name compare:selectedObject.name] == NSOrderedSame) {
                
                [self.picker selectRow:idx inComponent:0 animated:NO];
                [self.pickerDelegate selectedObjectID:self.selectedObjectID changedForPickerTextField:self];
                *stop = YES;
            }
        }];
    }
}


-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    Medication *medication = [self.pickerData objectAtIndex:row];
    return medication.name;
}


@end
