//
//  PatientViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Patient.h"
#import "Medication.h"
#import "MedicationPickerTextField.h"
#import "MedicationTwoPickerTextField.h"
#import "MedicationThreePickerTextField.h"

#define kOFFSET_FOR_KEYBOARD 36;

@interface PatientViewController : UIViewController <UITextFieldDelegate, CoreDataPickerTextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *diseaseTextField;

@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;
@property (nonatomic) BOOL addPressed;

@property (weak, nonatomic) IBOutlet MedicationPickerTextField *medicationPickerTextField;
@property (weak, nonatomic) IBOutlet MedicationTwoPickerTextField *medicationTwoPickerTextField;
@property (weak, nonatomic) IBOutlet MedicationThreePickerTextField *medicationThreePickerTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
