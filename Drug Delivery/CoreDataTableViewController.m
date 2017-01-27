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
    NSString *header = [[[self.frc sections] objectAtIndex:section] name];
   /* UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    CGRect frame = headerView.frame;
    frame.size.width = 300;
    frame.size.height = UIViewAutoresizingFlexibleHeight;
    headerView.frame = frame;
    [headerView sizeToFit];
    [tableView setTableHeaderView:headerView];*/
    //return [[[self.frc sections] objectAtIndex:section] name];
    return header;
}

/*- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return [self.frc sectionIndexTitles];
}*/

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
