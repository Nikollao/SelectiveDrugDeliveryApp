//
//  PatientTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "PatientTableViewController.h"
#import "PatientViewController.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "Patient.h"
#import "Medication.h"
#import "SetupWRCDeviceTableViewController.h"

@interface PatientTableViewController ()

@end

@implementation PatientTableViewController

-(void)configureFetch {
    
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Patient"];
    request.sortDescriptors = [NSArray arrayWithObjects:
                              //[NSSortDescriptor sortDescriptorWithKey:@"medication.name" ascending:YES],
                               //[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"lastNameFirstChar" ascending:YES],
                               nil];
    [request setFetchBatchSize:15];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"lastNameFirstChar" cacheName:nil];
    self.frc.delegate = self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
    [self hideKeyboardWhenBackgroundIsTapped];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

-(void) hideKeyboardWhenBackgroundIsTapped {
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
}

-(void) hideKeyboard {
    
    [self.tableView endEditing:YES];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"patient cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Patient *patient = [self.frc objectAtIndexPath:indexPath];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@ %@",patient.firstName, patient.lastName];
    
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = patient.disease;
    
    // update the tableView assign patient so the setup tableView updates automatically if you change the drug to a patient
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Patient *patientToDelete = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:patientToDelete];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PatientViewController *pvc = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"add patient"]) {
        
        CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
        Patient *newPatient = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:cdh.context];
        NSError *error = nil;
        
        [cdh.context obtainPermanentIDsForObjects:[NSArray arrayWithObject:newPatient] error:&error];
        pvc.selectedObjectID = newPatient.objectID;
        self.addPressed = YES;
    }
    else if ([[segue identifier] isEqualToString:@"edit patient"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        pvc.selectedObjectID = [[self.frc objectAtIndexPath:indexPath] objectID];
        self.addPressed = NO;
    }
    pvc.addPressed = self.addPressed;
}

@end
