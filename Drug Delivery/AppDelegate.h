//
//  AppDelegate.h
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "ScanBLEViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CoreDataHelper *coreDataHelper;
@property (strong, nonatomic) ScanBLEViewController *svc;

-(CoreDataHelper *)cdh;

@end

