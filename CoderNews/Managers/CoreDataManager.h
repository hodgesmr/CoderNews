//
//  CoreDataManager.h
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
- (BOOL) storyExistsWithTitle:(NSString *)title;
- (void) setUrlVisited:(NSString*)url;
- (void) fetchNewDataFromNetwork;
- (void) deleteStoriesOlderThanDays:(int)days;
+ (CoreDataManager *)sharedManager;

@end
