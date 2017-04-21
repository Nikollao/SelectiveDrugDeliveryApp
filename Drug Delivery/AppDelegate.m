//
//  AppDelegate.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(CoreDataHelper *)cdh{
    
    if (!_coreDataHelper) {
        
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^ {
            _coreDataHelper = [CoreDataHelper new];
        });
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    self.svc = [ScanBLEViewController shareSvc];
    NSString *message = @"b"; // inform MCR that bluetooth connection is lost
    NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
    CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
    if (self.svc.connectedPeripheral.state == CBPeripheralStateConnected) {
        [self.svc.connectedPeripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
        [self.svc.centralManager cancelPeripheralConnection:self.svc.connectedPeripheral];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self cdh] saveContext];
    
    self.svc = [ScanBLEViewController shareSvc];
    NSString *message = @"b";
    NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
    CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
    if (self.svc.connectedPeripheral.state == CBPeripheralStateConnected) {
        [self.svc.connectedPeripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
        [self.svc.centralManager cancelPeripheralConnection:self.svc.connectedPeripheral];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cdh];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self cdh] saveContext];
    
    self.svc = [ScanBLEViewController shareSvc];
    NSString *message = @"b";
    NSData *data = [NSData dataWithBytes:[message UTF8String] length:[message length]];
    CBCharacteristic *writeChar = [self.svc.bleService.characteristics firstObject];//objectAtIndex:0
    if (self.svc.connectedPeripheral.state == CBPeripheralStateConnected) {
        [self.svc.connectedPeripheral writeValue:data forCharacteristic:writeChar type:CBCharacteristicWriteWithResponse];
        [self.svc.centralManager cancelPeripheralConnection:self.svc.connectedPeripheral];
    }
}


@end
