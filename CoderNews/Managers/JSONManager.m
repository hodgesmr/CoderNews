//
//  JSONManager.m
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "JSONManager.h"
#import "AFJSONRequestOperation.h"

static NSString* const proggitUrl = @"http://www.reddit.com/r/programming/.json";
static NSString* const hackerNewsUrl = @"http://hndroidapi.appspot.com/news/format/json/page/?appid=Coder%20News";

static JSONManager *_sharedJSONManagerInsance;

@implementation JSONManager
@synthesize operations;

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

- (void) enqueueOperations {
    [self enqueueBatchOfHTTPRequestOperations:operations
                                progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                    NSLog(@"Finished %d of %d", numberOfFinishedOperations, totalNumberOfOperations);
                                }
                              completionBlock:^(NSArray *operations) {
                                  NSLog(@"All operations finished");
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"Compare Everything" object:nil];
                              }];
}

- (AFHTTPRequestOperation *)fetchJSON:(NSString*)requestUrl {
    
    NSURL* jsonUrl = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:jsonUrl];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if([requestUrl isEqualToString:proggitUrl]) {
            NSLog(@"%@ %@", requestUrl, [[JSON valueForKeyPath:@"data"] valueForKey:@"children"]);
        }
        else if([requestUrl isEqualToString:hackerNewsUrl]) {
            NSLog(@"%@ %@", requestUrl, [JSON valueForKeyPath:@"items"]);
        }
    } failure:nil];
    
    return operation;
}

@end
