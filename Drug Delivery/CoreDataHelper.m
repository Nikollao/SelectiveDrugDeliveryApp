//
//  CoreDataHelper.m
//  Drug Delivery
//
//  Created by Nikollao Sulollari on 23/01/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

// This is the Core Data Initialisation class
// It can be initialised in the AppDelegate
// Implementation of Core Data Helper
// database name
NSString *storeFileName = @"Drug-Delivery.sqlite";

// need to find out application directory

- (NSString *) applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// Need to find the URL for the app stores Directory

- (NSURL *) applicationStoresDirectory {
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        
        [fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return storesDirectory;
}

-(NSURL *)storesURL {
    
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:storeFileName];
}

- (id) init {
    
    self = [super init];
    if (self) {
        
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:_coordinator];
        
    }
    return self;
}

- (void) loadStore {
    
    if (!_store) {
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storesURL] options:nil error:nil];
        NSLog(@"Store Loaded");
    }
}

-(void)setupCoreData {
    
    [self loadStore];
}

-(void)saveContext{
    
    if ([_context hasChanges]) {
        
        [_context save:nil];
    }
}


@end
