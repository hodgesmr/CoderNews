//
//  CoreDataManager.m
//  CoderNews
//
//  Created by hodgesmr on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static CoreDataManager *_sharedInstance;

+ (CoreDataManager *) sharedManager {
    if (!_sharedInstance)
        _sharedInstance = [CoreDataManager new];
    return _sharedInstance;
}

#pragma mark - CRUD

- (NSFetchedResultsController *)fetchStoryInfosById {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetechedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    
    return theFetechedResultsController;
}

- (BOOL) persistStoryWithTitle:(NSString *)title url:(NSString *)url source:(NSString *)source {
    StoryInfo* si = [NSEntityDescription insertNewObjectForEntityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    si.title = title;
    si.source = source;
    si.url = url;
    si.visited = [NSNumber numberWithBool:NO];
    si.date = [NSDate date];
    NSDecimalNumber* uidDecimal = [NSDecimalNumber decimalNumberWithString:[self getLastUid]];
    uidDecimal = [uidDecimal decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
    si.uid = [uidDecimal stringValue];
    NSError* error;
    if(![self.managedObjectContext save:&error]) {
        return NO;
    }
    return YES;
}

- (NSString *) getLastUid {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"uid" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchLimit:1];
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    StoryInfo* si = [results objectAtIndex:0];
    return si.uid;
}

- (int) countEntries {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    int count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if(count == NSNotFound) {
        count = 0;
    }
    return count;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoderNews" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoderNews.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
