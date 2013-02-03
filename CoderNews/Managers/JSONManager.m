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
//static NSString* const hackerNewsUrl = @"http://hndroidapi.appspot.com/news/format/json/page/?appid=Coder%20News";

@implementation JSONManager

+ (JSONManager *)sharedJSONManager {
    
    NSMutableArray* operations = [NSMutableArray arrayWithCapacity:2];
    [operations addObject:[self operationToFetchJSON:proggitUrl]];
    //[operations addObject:[self operationToFetchJSON:hackerNewsUrl]];
    
    static JSONManager *sharedJSONManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedJSONManager = [[JSONManager alloc] initWithBaseURL:[NSURL URLWithString:proggitUrl]];
        [sharedJSONManager enqueueBatchOfHTTPRequestOperations:operations
                                                 progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                                     NSLog(@"Finished %d of %d", numberOfFinishedOperations, totalNumberOfOperations);
                                                 }
                                               completionBlock:^(NSArray *operations) {
                                                   NSLog(@"All operations finished");
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"Compare Everything" object:nil];
                                               }];
    });
    
    return sharedJSONManager;
}

+(AFHTTPRequestOperation *)operationToFetchJSON:(NSString*)requestUrl {
    
    NSURL* jsonUrl = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:jsonUrl];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"IP Address: %@", [JSON stringValue]);
    } failure:nil];
    
    return operation;
}





@end
