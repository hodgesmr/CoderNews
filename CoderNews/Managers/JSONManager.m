//
//  JSONManager.m
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "CoreDataManager.h"
#import "JSONManager.h"
#import "FetchedStory.h"
#import "PreferencesManager.h"

static NSString* const proggitUrl = @"http://www.reddit.com/r/programming/.json";
static NSString* const hackerNewsUrl = @"http://api.ihackernews.com/page";

static JSONManager *_sharedJSONManagerInsance;

@implementation JSONManager
@synthesize operations;
@synthesize fetchedStories;
@synthesize fetchedHackerNewsStories;
@synthesize fetchedProggitStories;

+ (JSONManager *) sharedJSONManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedJSONManagerInsance = [[JSONManager alloc] initWithBaseURL:[NSURL URLWithString:proggitUrl]];
    });
    return _sharedJSONManagerInsance;
}

- (void) mergeFetchedStories {
    int i = 0;
    int hnLen = [self.fetchedHackerNewsStories count];
    int prLen = [self.fetchedProggitStories count];
    
    while(i < hnLen || i < prLen) {
        if(i < hnLen) {
            [self.fetchedStories insertObject:[self.fetchedHackerNewsStories objectAtIndex:i] atIndex:0];
        }
        if(i < prLen) {
            [self.fetchedStories insertObject:[self.fetchedProggitStories objectAtIndex:i] atIndex:0];
        }
        i++;
    }
}

- (void) pruneUnwantedStories {
    NSMutableIndexSet* deathIndexes = [[NSMutableIndexSet alloc] init];
    // I don't want the following:
    for(int i=0; i<[self.fetchedStories count]; i++) {
        FetchedStory* fs = [self.fetchedStories objectAtIndex:i];
        // HN score below 20
        if([fs.source isEqualToString:@"hackernews"] && [fs.score doubleValue] < 20) {
            [deathIndexes addIndex:i];
        }
        // Proggit score below 10
        else if([fs.source isEqualToString:@"proggit"] && [fs.score doubleValue] < 10) {
            [deathIndexes addIndex:i];
        }
        // 'Ask HN' posts
        else if([[fs.title lowercaseString] rangeOfString:@"ask hn"].location != NSNotFound) {
            [deathIndexes addIndex:i];
        }
        // 'Poll:' posts
        else if([[fs.title lowercaseString] rangeOfString:@"poll:"].location != NSNotFound) {
            [deathIndexes addIndex:i];
        }
        // urls that don't start with http
        else if(![[[fs.url substringToIndex:4] lowercaseString] isEqualToString:@"http"]) {
            [deathIndexes addIndex:i];
        }
        // we already have the story
        else if([[CoreDataManager sharedManager] storyExistsWithUrl:fs.url]) {
            [deathIndexes addIndex:i];
        }
    }
    
    [self.fetchedStories removeObjectsAtIndexes:deathIndexes];
}

- (void) loadOperations {
    _sharedJSONManagerInsance.operations = [NSMutableArray arrayWithCapacity:2];
    if([[PreferencesManager sharedPreferencesManager] requiresProggit]) {
        [_sharedJSONManagerInsance.operations addObject:[self fetchJSON:proggitUrl]];
    }
    if([[PreferencesManager sharedPreferencesManager] requiresHackerNews]) {
        [_sharedJSONManagerInsance.operations addObject:[self fetchJSON:hackerNewsUrl]];
    }
}

- (void) executeOperations {
    [_sharedJSONManagerInsance loadOperations];
    _sharedJSONManagerInsance.fetchedStories = [[NSMutableArray alloc] init];
    _sharedJSONManagerInsance.fetchedProggitStories = [[NSMutableArray alloc] init];
    _sharedJSONManagerInsance.fetchedHackerNewsStories = [[NSMutableArray alloc] init];
    [self enqueueBatchOfHTTPRequestOperations:operations
                                progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                    // logging for troubleshooting
                                    // NSLog(@"Finished %d of %d", numberOfFinishedOperations, totalNumberOfOperations);
                                }
                              completionBlock:^(NSArray *operations) {
                                  [self mergeFetchedStories];
                                  [self pruneUnwantedStories];
                                  [[CoreDataManager sharedManager] persistFetchedStories:_sharedJSONManagerInsance.fetchedStories];
                                  _sharedJSONManagerInsance.operations = nil;
                                  // logging for troubleshooting
                                  // NSLog(@"All operations finished");
                              }];
}

- (AFHTTPRequestOperation *)fetchJSON:(NSString*)requestUrl {
    
    NSURL* jsonUrl = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:jsonUrl];
    AFJSONRequestOperation *operation = nil;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if([requestUrl isEqualToString:proggitUrl]) {
            
            NSArray* arr = [[JSON valueForKeyPath:@"data"] valueForKey:@"children"];
            for (NSDictionary *item in arr) {
                FetchedStory* fs = [[FetchedStory alloc] init];
                fs.title = [[item valueForKey:@"data"]valueForKey:@"title"];
                fs.url = [[item valueForKey:@"data"]valueForKey:@"url"];
                fs.score = [[item valueForKey:@"data"]valueForKey:@"score"];
                fs.source = @"proggit";
                [self.fetchedProggitStories addObject:fs];
            }
        }
        else if([requestUrl isEqualToString:hackerNewsUrl]) {
            NSArray* arr = [JSON valueForKeyPath:@"items"];
            for (NSDictionary *item in arr) {
                FetchedStory* fs = [[FetchedStory alloc] init];
                fs.title = [item valueForKey:@"title"];
                // I don't want the 'Show HN' part of the title
                if([[fs.title lowercaseString] rangeOfString:@"show hn: "].location != NSNotFound) {
                    fs.title = [fs.title substringFromIndex:9];
                }
                fs.url = [item valueForKey:@"url"];
                fs.score = [item valueForKey:@"points"];
                fs.source = @"hackernews";
                [self.fetchedHackerNewsStories addObject:fs];
            }
        }
    } failure:nil];
    
    return operation;
}

@end
