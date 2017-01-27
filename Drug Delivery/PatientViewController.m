//
//  PatientViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "PatientViewController.h"

#import "MedicationPickerTextField.h"


@interface PatientViewController ()

@end

@implementation PatientViewController

-(void)hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void)hideKeyboard {
    
    [self.view endEditing:YES];
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    //[self.firstNameTextField becomeFirstResponder];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.diseaseTextField.delegate = self;
    self.dateOfBirthTextField.delegate = self;
    self.medicationPickerTextField.delegate = self;
    self.medicationPickerTextField.pickerDelegate = self;
    
    if (self.addPressed) {
     self.navigationItem.title = @"Add Patient";
    } else {
        self.navigationItem.title = @"Edit Patient";
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self refreshInterface];
    [self ensureMedicationIsNotNone];
    [self.firstNameTextField becomeFirstResponder];
}

-(void)ensureMedicationIsNotNone {
    
    if (self.selectedObjectID) {
        
        CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
        Patient *patient = (Patient *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        MedicationPickerTextField *mpt = [[MedicationPickerTextField alloc] init];
        NSLog(@"%ld",[mpt.pickerData count]);
        //
        if (![mpt.pickerData count]) {
            
            NSFetchRequest *request = [[cdh model] fetchRequestTemplateForName:@"NoMedication"];
            NSArray *fetchedObjects = [cdh.context executeFetchRequest:request error:nil];
            
            if ([fetchedObjects count] > 0) {
                
                patient.medication = [fetchedObjects objectAtIndex:0];
            } else {
                
                Medication *medication = [NSEntityDescription insertNewObjectForEntityForName:@"Medication" inManagedObjectContext:cdh.context];
                // [cdh.context obtainPermanentIDsForObjects:fetchedObjects error:nil];
                medication.name = @"No Medicaiton";
                patient.medication = medication;
            }
        }
    }
}

-(void)refreshInterface {
    
    if (self.selectedObjectID) {
        
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Patient *patient = (Patient *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        self.firstNameTextField.text = patient.firstName;
        self.lastNameTextField.text = patient.lastName;
        self.diseaseTextField.text = patient.disease;
        self.dateOfBirthTextField.text = patient.dateOfBirth;
        self.medicationPickerTextField.text = patient.medication.name;
        self.medicationPickerTextField.selectedObjectID = patient.medication.objectID;
        //[self hideKeyboard];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self ensureMedicationIsNotNone];
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}


- (IBAction)cancel:(id)sender {
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh.context rollback];
    
}

- (IBAction)save:(id)sender {
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}

#pragma mark - PICKERS

-(void)selectedObjectID:(NSManagedObjectID *)objectID changedForPickerTextField:(CoreDataPickerTextField *)pickerTextField {
    
    if (self.selectedObjectID) {
        
        CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
        Patient *patient = (Patient *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        if (pickerTextField == self.medicationPickerTextField) {
            
            Medication *medication = (Medication *)[cdh.context existingObjectWithID:objectID error:nil];
            patient.medication = medication;
            self.medicationPickerTextField.text = patient.medication.name;
        }
        [self refreshInterface];
    }
}

-(void)selectedobjectClearedForPickerTextField:(CoreDataPickerTextField *)pickerTextField {
    
    if (self.selectedObjectID) {
        
        CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
        Patient *patient = (Patient *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        
        if (pickerTextField == self.medicationPickerTextField) {
            
            patient.medication = nil;
            self.medicationPickerTextField.text = @"";
        }
        [self refreshInterface];
    }
}

#pragma mark - DELEGATE: TextField

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    if (textField == _medicationPickerTextField && _medicationPickerTextField.picker) {
        
        [_medicationPickerTextField fetch];
        [_medicationPickerTextField.picker reloadAllComponents];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    
    NSError *error = nil;
    Patient *patient = (Patient *)[cdh.context existingObjectWithID:self.selectedObjectID error:&error];
    if (error) {
        
        NSLog(@"Application terminates with error %@",error);
        //abort();
    }
    
    if (textField == self.firstNameTextField) {
        
        patient.firstName = self.firstNameTextField.text;
    }
    if (textField == self.lastNameTextField) {

        patient.lastName = self.lastNameTextField.text;
    }
    
    if (textField == self.diseaseTextField) {
        
        patient.disease = self.diseaseTextField.text;
    }
    if (textField == self.dateOfBirthTextField) {
        
        patient.dateOfBirth = self.dateOfBirthTextField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self hideKeyboard];
    return YES;
}

@end
