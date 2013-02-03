//
//  JSONManager.m
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AFJSONRequestOperation.h"
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
                fs.source = @"proggit";
                [fetchedStories addObject:fs];
            }
        }
        else if([requestUrl isEqualToString:hackerNewsUrl]) {
            NSArray* arr = [JSON valueForKeyPath:@"items"];
            for (NSDictionary *item in arr) {
                FetchedStory* fs = [[FetchedStory alloc] init];
                fs.title = [item valueForKey:@"title"];
                fs.url = [item valueForKey:@"url"];
                fs.source = @"hackernews";
                [fetchedStories addObject:fs];
            }
        }
    } failure:nil];
    
    return operation;
}

@end
