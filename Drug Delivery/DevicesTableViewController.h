//
//  DevicesTableViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 27/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DevicesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *testButton;
@property (strong, nonatomic) NSString *sendString;

@property (strong, nonatomic) NSMutableArray *peripheralsArray;

@end
