//
//  CoreDataManager.h
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryInfo.h"

@protocol CoreDataDelegate

-(void)newDataAvailable;

@end

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak) id<CoreDataDelegate> delegate;


- (NSURL *)applicationDocumentsDirectory;
- (NSFetchedResultsController *)fetchStoryInfosById;
- (BOOL) persistStoryWithTitle:(NSString *)title url:(NSString *)url source:(NSString *)source;
- (void) persistFetchedStories:(NSArray*)fetchedStories;
- (void) clearCoreData;
- (BOOL) storyExistsWithUrl:(NSString *)url;
- (void) setUrlVisited:(NSString*)url;
- (void) fetchNewDataFromNetwork;
- (void) deleteStoriesOlderThanDays:(int)days;
+ (CoreDataManager *)sharedManager;

@end
