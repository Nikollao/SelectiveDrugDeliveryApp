//
//  MedicationViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface MedicationViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *drugNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *drugInstructionsTextView;

@property (strong, nonatomic) NSManagedObjectID *selectedObjectID;
@property (nonatomic) BOOL addPressed;

@end
