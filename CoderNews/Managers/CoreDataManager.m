//
//  CoreDataManager.m
//  CoderNews (https://github.com/hodgesmr/CoderNews)
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges (http://matthodges.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CoreDataManager.h"
#import "FetchedStory.h"
#import "JSONManager.h"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static CoreDataManager *_sharedInstance;

+ (CoreDataManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CoreDataManager alloc] init];
    });
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
    if([self storyExistsWithUrl:url] || [self storyExistsWithTitle:title]) {
        return YES;
    }
    StoryInfo* si = [NSEntityDescription insertNewObjectForEntityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    si.title = title;
    si.source = source;
    si.url = url;
    si.visited = [NSNumber numberWithBool:NO];
    si.date = [NSDate date];
    si.uid = [NSNumber numberWithLongLong:[[self getLastUid] longLongValue] + 1];
    NSError* error;
    if(![self.managedObjectContext save:&error]) {
        return NO;
    }
    return YES;
}

- (void) persistFetchedStories:(NSArray*)fetchedStories {
    for(FetchedStory* fs in fetchedStories) {
        [[CoreDataManager sharedManager] persistStoryWithTitle:fs.title url:fs.url source:fs.source];
    }
    [self.delegate newDataAvailable];
}

- (void) fetchNewDataFromNetwork {
    [[JSONManager sharedJSONManager] executeOperations];
}

- (NSNumber *) getLastUid {
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

- (void) deleteStoriesOlderThanDays:(int)days {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSDate* today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    [components setHour:-(24*days)];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *nDaysAgo = [cal dateByAddingComponents:components toDate: today options:0];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date < %@", nDaysAgo];
    [fetchRequest setPredicate:predicate];
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(results != nil && [results count] && error == nil) {
        for(int i=0; i<[results count]; i++) {
            [self.managedObjectContext deleteObject:[results objectAtIndex:i]];
        }
        error = nil;
        [self.managedObjectContext save:&error];
    }
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

- (BOOL) storyExistsWithUrl:(NSString *)url {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(result != nil && [result count] && error == nil) {
        return YES;
    }
    return NO;
}

- (BOOL) storyExistsWithTitle:(NSString *)title {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(result != nil && [result count] && error == nil) {
        return YES;
    }
    return NO;
}

- (void) setUrlVisited:(NSString*)url {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", url];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(result != nil && [result count] && error == nil) {
        StoryInfo* si = [result objectAtIndex:0];
        si.visited = [NSNumber numberWithBool:YES];
        error = nil;
        [self.managedObjectContext save:&error];
    }
}

-(void)clearCoreData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!error) {
        for (NSManagedObject *object in objects) {
            [self.managedObjectContext deleteObject:object];
        }
    }
    else {
        [self deletePersistentStore];
    }
    error = nil;
    if (![self.managedObjectContext save:&error]) {
        [self deletePersistentStore];
    }
}

-(void)deletePersistentStore {
    // Wipe the database file directly
    NSError *error = nil;
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    NSError *fileError = nil;
    NSURL *storeURL = store.URL;
    [self.persistentStoreCoordinator removePersistentStore:store error:&fileError];
    fileError = nil;
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&fileError];
    // Create an empty database file to replace it
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // do something with the error
    }
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
