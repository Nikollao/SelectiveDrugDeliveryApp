//
//  DataExchangeViewController.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 26/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kOFFSET_FOR_KEYBOARD 225.0

@interface DataExchangeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;

@end
