//
//  Medication+CoreDataClass.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient;

@interface Medication : NSManagedObject

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nameFirstChar;
@property (nullable, nonatomic, copy) NSString *instructions;

@property (nullable, nonatomic, retain) NSSet<Patient *> *patients;
@property (nullable, nonatomic, retain) NSSet<Patient *> *patientsTwo;
@property (nullable, nonatomic, retain) NSSet<Patient *> *patientsThree;



@end


