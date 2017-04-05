//
//  CoreDataTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController ()

@end

@implementation CoreDataTableViewController

-(void)performFetch {
    
    if (self.frc) {
        
        [self.frc.managedObjectContext performBlockAndWait:^{
            [self.frc performFetch:nil];
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - DATASOURCE: UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[self.frc sections] objectAtIndex:section] numberOfObjects];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.frc sections] count];
}

-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return [self.frc sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    /*NSString *lastNameOfPatient = [[[self.frc sections] objectAtIndex:section] name];
    
    if ([lastNameOfPatient length] > 0) {
        NSString *firstCharFromLastName = [lastNameOfPatient substringToIndex:1];
        return firstCharFromLastName;
    } else
        return @" ";*/
    return [[[self.frc sections] objectAtIndex:section] name];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return [self.frc sectionIndexTitles];
    // we don't want index if we are doing search, only in the original tableView
    /*if (tableView.tag == 1) {
        return [self.frc sectionIndexTitles];
    } else {
        return nil;
    }*/
}

#pragma mark - DELEGATE: NSFetchedResultsController

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller  {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    if (type == NSFetchedResultsChangeInsert) {
        
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeUpdate) {
        
        if (!newIndexPath) { // if update has happened in the same row (same indexPath)
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else { // updata has occured in different row
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if (type == NSFetchedResultsChangeMove) {
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
