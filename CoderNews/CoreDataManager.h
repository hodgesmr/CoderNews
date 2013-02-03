//
//  CoreDataManager.h
//  CoderNews
//
//  Created by hodgesmr on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryInfo.h"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory;
- (NSFetchedResultsController *)fetchStoryInfosById;
- (BOOL) persistStoryWithTitle:(NSString *)title url:(NSString *)url source:(NSString *)source;
+(CoreDataManager *)sharedManager;

@end
