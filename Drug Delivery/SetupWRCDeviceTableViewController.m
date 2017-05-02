//
//  SetupWRCDeviceTableViewController.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 10/04/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "SetupWRCDeviceTableViewController.h"
#import "PatientViewController.h"
#import "SetupWRCViewController.h"

@interface SetupWRCDeviceTableViewController ()

@end

@implementation SetupWRCDeviceTableViewController

static SetupWRCDeviceTableViewController *_sharedInstance;

+(SetupWRCDeviceTableViewController *) sharedInstance {
    
    if (!_sharedInstance) {
        _sharedInstance = [[SetupWRCDeviceTableViewController alloc] init];
    }
    return _sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.deliverDrugButton.enabled = NO;
    self.svc = [ScanBLEViewController shareSvc];
    
    if (!_sharedInstance) {
        _sharedInstance = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
    PatientViewController *pvc = [PatientViewController sharedObject];
    if (pvc.updatePush && [_patientName length]) {
        NSLog(@"Push = %d",pvc.updatePush);
        pvc.updatePush = NO;
        _patientName = nil;
        [self.tableView reloadData];
    }
    else {
        NSLog(@"Connected device: %@, patient name: %@",_svc.connectedPeripheral.name, _patientName);
    }
    if ([_patientName length] && _svc.connectedPeripheral) {
        self.deliverDrugButton.enabled = YES;
    }
    else {
        self.deliverDrugButton.enabled = NO;
    }
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
    NSString *subTitle = [[NSString alloc] init];
    
    if (indexPath.section == 0) {
        
        titleCell = _svc.peripheralNameDisplay;
        //titleCell = @"Test";
        //NSLog(@"cell should be: %@",_svc.connectedPeripheral.name);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (indexPath.section == 1) {
        
        // assign patient
        titleCell = _patientName;
        NSLog(@"Name: %@",_patientName);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 2) {
        
        // assign medication
        if (indexPath.row == 0) {
            
            if ([self.firstChamber length]) {
                titleCell = @"Chamber 1:";
                subTitle = self.firstChamber;
            }
        }
        else if (indexPath.row == 1) {
            
            if ([self.secondChamber length]) {
                titleCell = @"Chamber 2:";
                subTitle = _secondChamber;
            }
        }
        else if (indexPath.row == 2) {
           
            if ([self.thirdChamber length]) {
                titleCell = @"Chamber 3:";
                subTitle = _thirdChamber;
            }
        }
    }
    cell.textLabel.text = titleCell;
    cell.detailTextLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.text = subTitle;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"drug deliver segue"]) {
        
        SetupWRCViewController *setupVC = [segue destinationViewController];
        NSArray *array = [NSArray arrayWithObjects:self.firstChamber,self.secondChamber,self.thirdChamber, nil];
        setupVC.chambers = array;
    }
}


@end
