//
//  Patient.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Medication;


@interface Patient : NSManagedObject

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *lastNameFirstChar;
@property (nullable, nonatomic, copy) NSString *dateOfBirth;
@property (nullable, nonatomic, copy) NSString *disease;
@property (nullable, nonatomic, copy) NSString *patientID;
@property (nullable, nonatomic, copy) NSString *address;

@property (nonatomic) int64_t numberOfDrugs;
// first medication relationship
@property (nullable, nonatomic, retain) Medication *medication;
// second medication relationship
@property (nullable, nonatomic, retain) Medication *medicationTwo;
// third medication relationship
@property (nullable, nonatomic, retain) Medication *medicationThree;

@end

