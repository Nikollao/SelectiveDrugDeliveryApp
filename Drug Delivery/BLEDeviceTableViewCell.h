//
//  BLEDeviceTableViewCell.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 10/02/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEDeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@property (nonatomic) BOOL isConnected;

@end
