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

static NSString* const proggitUrl = @"http://www.reddit.com/r/programming/.json";
static NSString* const hackerNewsUrl = @"http://hndroidapi.appspot.com/news/format/json/page/?appid=Coder%20News";

static JSONManager *_sharedJSONManagerInsance;

@implementation JSONManager
@synthesize operations;
@synthesize fetchedStories;

+ (JSONManager *) sharedJSONManager {
    if (!_sharedJSONManagerInsance) {
        _sharedJSONManagerInsance = [JSONManager new];
        _sharedJSONManagerInsance = [[JSONManager alloc] initWithBaseURL:[NSURL URLWithString:proggitUrl]];
        [_sharedJSONManagerInsance loadOperations];
        
    }
    return _sharedJSONManagerInsance;
}

- (void) shuffleResults {
    NSUInteger count = [self.fetchedStories count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.fetchedStories exchangeObjectAtIndex:i withObjectAtIndex:n];
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
        // 'Show HN' posts
        else if([[fs.title lowercaseString] rangeOfString:@"show hn"].location != NSNotFound) {
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
        // The HN API that I'm using doesn't do a good job of handling UTF-8 characters
        // that have been HTML encoded. Because of this, we're getting some garbage back.
        // I haven't come up with a good way to deal with this yet, so for now I'm just
        // going to throw out all stories that have a semi-colon. Yes, we're going to lose
        // some stories, but I don't care.
        else if([fs.title rangeOfString:@";"].location != NSNotFound) {
            [deathIndexes addIndex:i];
        }
    }
    
    [self.fetchedStories removeObjectsAtIndexes:deathIndexes];
}

- (void) loadOperations {
    _sharedJSONManagerInsance.operations = [NSMutableArray arrayWithCapacity:2];
    [_sharedJSONManagerInsance.operations addObject:[self fetchJSON:proggitUrl]];
    [_sharedJSONManagerInsance.operations addObject:[self fetchJSON:hackerNewsUrl]];
}

- (void) executeOperations {
    _sharedJSONManagerInsance.fetchedStories = [[NSMutableArray alloc] init];
    [self enqueueBatchOfHTTPRequestOperations:operations
                                progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                    NSLog(@"Finished %d of %d", numberOfFinishedOperations, totalNumberOfOperations);
                                }
                              completionBlock:^(NSArray *operations) {
                                  // I don't like the hn and proggit results being grouped together, so shuffle
                                  [self shuffleResults];
                                  [self pruneUnwantedStories];
                                  for(FetchedStory* fs in _sharedJSONManagerInsance.fetchedStories) {
                                      [[CoreDataManager sharedManager] persistStoryWithTitle:fs.title url:fs.url source:fs.source];
                                  }
                                  NSLog(@"All operations finished");
                              }];
}

- (AFHTTPRequestOperation *)fetchJSON:(NSString*)requestUrl {
    
    NSURL* jsonUrl = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:jsonUrl];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if([requestUrl isEqualToString:proggitUrl]) {
            
            NSArray* arr = [[JSON valueForKeyPath:@"data"] valueForKey:@"children"];
            for (NSDictionary *item in arr) {
                FetchedStory* fs = [[FetchedStory alloc] init];
                fs.title = [[item valueForKey:@"data"]valueForKey:@"title"];
                fs.url = [[item valueForKey:@"data"]valueForKey:@"url"];
                fs.score = [[item valueForKey:@"data"]valueForKey:@"score"];
                fs.source = @"proggit";
                [self.fetchedStories addObject:fs];
            }
        }
        else if([requestUrl isEqualToString:hackerNewsUrl]) {
            NSArray* arr = [JSON valueForKeyPath:@"items"];
            for (NSDictionary *item in arr) {
                FetchedStory* fs = [[FetchedStory alloc] init];
                fs.title = [item valueForKey:@"title"];
                fs.url = [item valueForKey:@"url"];
                NSString* scoreString = [item valueForKey:@"score"];
                if(scoreString != nil && [scoreString length]!=0) {
                    NSRange spaceRange = [scoreString rangeOfString:@" "];
                    scoreString = [scoreString substringToIndex:spaceRange.location];
                    fs.score = [NSDecimalNumber decimalNumberWithString:scoreString];
                    fs.source = @"hackernews";
                    [self.fetchedStories addObject:fs];
                }
            }
        }
    } failure:nil];
    
    return operation;
}

@end
