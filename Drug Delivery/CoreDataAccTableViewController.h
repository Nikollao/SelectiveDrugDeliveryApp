//
//  CoreDataAccTableViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 08/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CoreDataAccTableViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *frc;

-(void) performFetch;

@end
