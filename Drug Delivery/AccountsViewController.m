//
//  AccountsViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 08/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "AccountsViewController.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "AccountHolder.h"

@interface AccountsViewController ()

@end

@implementation AccountsViewController

-(void)configureFetch {
    
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AccountHolder"];
    request.sortDescriptors = [NSArray arrayWithObjects:
                               [NSSortDescriptor sortDescriptorWithKey:@"fullNameFirstChar" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"occupation" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES],
                               nil];
    [request setFetchBatchSize:15];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:cdh.context sectionNameKeyPath:@"fullNameFirstChar" cacheName:nil];
    self.frc.delegate = self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self configureFetch];
    [self performFetch];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    AccountHolder *holder = [self.frc objectAtIndexPath:indexPath];
    
    //NSMutableString *title = [NSMutableString stringWithFormat:@"%@ %@",holder.userName, holder.password];
    
    //[title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    
    NSMutableString *title = [NSMutableString stringWithFormat:@"%@",holder.fullName];
    
    [title replaceOccurrencesOfString:@"(null)" withString:@"" options:0 range:NSMakeRange(0, [title length])];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = holder.occupation;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AccountHolder *deleteHolder = [self.frc objectAtIndexPath:indexPath];
        [self.frc.managedObjectContext deleteObject:deleteHolder];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    CoreDataHelper *cdh = [(AppDelegate *) [[UIApplication sharedApplication] delegate] cdh];
    [cdh saveContext];
}


@end
