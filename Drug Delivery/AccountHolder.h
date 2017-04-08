//
//  AccountHolder.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 08/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AccountHolder : NSManagedObject

@property (nullable, nonatomic, copy) NSString *fullName;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *repeatPassword;
@property (nullable, nonatomic, copy) NSString *occupation;

@end
