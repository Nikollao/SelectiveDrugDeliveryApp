//
//  MedicationViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "MedicationViewController.h"
#import "Medication.h"
#import "AppDelegate.h"

@interface MedicationViewController ()

@end

@implementation MedicationViewController

-(void)hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tgr];
}

-(void)hideKeyboard {
    
    [self.view endEditing:YES];
}

-(void)refreshInterface {
    
    if (self.selectedObjectID) {
        
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        Medication *medication = [cdh.context existingObjectWithID:self.selectedObjectID error:nil];
        self.drugNameTextField.text = medication.name;
        self.drugInstructionsTextView.text = medication.instructions;
    }
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self hideKeyboardWhenBackgroundIsTapped];
    self.drugNameTextField.delegate = self;
    self.drugInstructionsTextView.delegate = self;
    
    if (self.addPressed) {
        
        self.navigationItem.title = @"Add Medication";
    } else {
        self.navigationItem.title = @"Edit Medication";
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self refreshInterface];
    [self.drugNameTextField becomeFirstResponder];
}

- (IBAction)save:(id)sender {
    
    if (![self.drugNameTextField.text length]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Drug Name cannot be blank!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^ (UIAlertAction *action) {}];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (![self.drugInstructionsTextView.text length]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Instructions cannot be blank!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^ (UIAlertAction *action) {}];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        [self hideKeyboard];
        CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
        if (!self.selectedObjectID) {
            
            Medication *newMedication = [NSEntityDescription insertNewObjectForEntityForName:@"Medication" inManagedObjectContext:cdh.context];
            newMedication.name = self.drugNameTextField.text;
            newMedication.nameFirstChar = [newMedication.name substringToIndex:1];
            newMedication.instructions = self.drugInstructionsTextView.text;
        }
        else if (self.selectedObjectID) {
            
            Medication *medication = (Medication *)[cdh.context existingObjectWithID:self.selectedObjectID error:nil];
            medication.name = self.drugNameTextField.text;
            medication.nameFirstChar = [medication.name substringToIndex:1];
            medication.instructions = self.drugInstructionsTextView.text;
        }
        [cdh saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh.context rollback];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self hideKeyboard];
    /* if ([self.drugNameTextField.text length]) {
        [self hideKeyboard];
    } else {
        
        [self hideKeyboard];
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        
        Medication *newMedication = [NSEntityDescription insertNewObjectForEntityForName:@"Medication" inManagedObjectContext:cdh.context];
        newMedication.name = self.drugNameTextField.text;
        newMedication.instructions = self.drugInstructionsTextView.text;
        [cdh saveContext];
    }*/
    return YES;
}


@end
