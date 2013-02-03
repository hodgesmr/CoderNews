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
    self.operations = [NSMutableArray arrayWithCapacity:2];
    [self.operations addObject:[self fetchJSON:proggitUrl]];
    [operations addObject:[self fetchJSON:hackerNewsUrl]];
}

- (void) executeOperations {
    self.fetchedStories = [[NSMutableArray alloc] init];
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
            for (NSDictionary *items in arr) {
                FetchedStory* fs = [[FetchedStory alloc] init];
                fs.title = [[items valueForKey:@"data"]valueForKey:@"title"];
                fs.url = [[items valueForKey:@"data"]valueForKey:@"url"];
                fs.source = @"proggit";
                [fetchedStories addObject:fs];
                NSLog(@"%@", [[items valueForKey:@"data"]valueForKey:@"title"]);
            }
            
            NSLog(@"%@ %@", requestUrl, [[JSON valueForKeyPath:@"data"] valueForKey:@"children"]);
            
        }
        else if([requestUrl isEqualToString:hackerNewsUrl]) {
            NSLog(@"%@ %@", requestUrl, [JSON valueForKeyPath:@"items"]);
        }
    } failure:nil];
    
    return operation;
}

@end
