//
//  SetupWRCDeviceTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 10/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "SetupWRCDeviceTableViewController.h"

@interface SetupWRCDeviceTableViewController ()

@end

@implementation SetupWRCDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.svc = [ScanBLEViewController shareSvc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"Connected device: %@",_svc.connectedPeripheral.name);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    NSInteger sections;
    
    if (_svc.connectedPeripheral) {
        //NSLog(@"%@",_svc.connectedPeripheral);
        sections = 2;
        if (_patientName) {
            sections++;
        }
    } else {
        sections = 0;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows;
    
    if (section == 0 || section == 1) {
        rows = 1;
    }
    else if (section == 2) {
        rows = _numberOfDrugs;
    }
    else {
        rows = 0;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setup WRC cell" forIndexPath:indexPath];
    
    NSString *titleCell = [[NSString alloc] init];
    
    if (indexPath.section == 0) {
        
        titleCell = _svc.connectedPeripheral.name;
        //NSLog(@"cell should be: %@",_svc.connectedPeripheral.name);
    }
    
    else if (indexPath.section == 1) {
        
        // assign patient
    }
    else if (indexPath.section == 2) {
        
        // assign medication
    }
    
    cell.textLabel.text = titleCell;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
    
    NSString *titleForSection = [[NSString alloc] init];
    
    if (section == 0) {
        titleForSection = @"Connected Device:";
    }
    else if (section == 1) {
        titleForSection = @"Assign Patient:";
    }
    else if (section == 2) {
        titleForSection = @"Medication:";
    }
    else {
        titleForSection = nil;
    }
    return titleForSection;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"assign patient VC"];
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
