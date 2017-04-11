//
//  AssignPatientTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 10/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "AssignPatientTableViewController.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "Patient.h"
#import "Medication.h"

@interface AssignPatientTableViewController ()

@end

@implementation AssignPatientTableViewController

-(void)configureFetch {
    
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Patient"];
    request.sortDescriptors = [NSArray arrayWithObjects:
                               [NSSortDescriptor sortDescriptorWithKey:@"medication.name" ascending:YES],
                               /*[NSSortDescriptor sortDescriptorWithKey:@"medicationTwo.name" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"medicationThree.name" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES],*/
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
    _stvc = [SetupWRCDeviceTableViewController sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    
    static NSString *cellIdentifier = @"assign patient cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Patient *patient = [self.frc objectAtIndexPath:indexPath];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@ %@",patient.firstName, patient.lastName];
    
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = patient.dateOfBirth;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*UILabel *selectedPatient = [[self.tableView cellForRowAtIndexPath:indexPath] textLabel];
    NSLog(@"patient: %@",selectedPatient.text);
    _stvc.patientName =selectedPatient.text;*/
    
    Patient *patient = [self.frc objectAtIndexPath:indexPath];
    
    _stvc.patientName = [NSString stringWithFormat:@"%@ %@",patient.firstName, patient.lastName];
    _stvc.firstChamber = patient.medication.name;
    _stvc.secondChamber = patient.medicationTwo.name;
    _stvc.thirdChamber = patient.medicationThree.name;
    _stvc.numberOfDrugs = patient.numberOfDrugs;
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Patient *patientToDelete = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:patientToDelete];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   /* PatientViewController *pvc = [segue destinationViewController];
    
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
    pvc.addPressed = self.addPressed; */
}


@end
