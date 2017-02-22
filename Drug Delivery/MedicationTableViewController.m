//
//  MedicationTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "MedicationTableViewController.h"
#import "MedicationViewController.h"
#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "Medication.h"

@interface MedicationTableViewController ()

@end

@implementation MedicationTableViewController

-(void)configureFetch {
    
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Medication"];
    request.sortDescriptors = [NSArray arrayWithObjects:
                               [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"instructions" ascending:YES],
                               nil];
    [request setFetchBatchSize:15];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"name" cacheName:nil];
    self.frc.delegate = self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"medication cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Medication *medication = [self.frc objectAtIndexPath:indexPath];
    cell.textLabel.text = medication.name;
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Medication *medicationToDelete = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:medicationToDelete];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}

- (IBAction)done:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MedicationViewController *mvc = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"add medication"]) {
        
        mvc.selectedObjectID = nil;
        self.addPressed = YES;
    }
    else if ([[segue identifier] isEqualToString:@"edit medication"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        mvc.selectedObjectID = [[self.frc objectAtIndexPath:indexPath] objectID];
        self.addPressed = NO;
    }
    mvc.addPressed = self.addPressed;
}

@end
