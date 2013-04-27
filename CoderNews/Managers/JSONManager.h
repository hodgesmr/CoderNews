//
//  JSONManager.h
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AFHTTPClient.h"

@interface JSONManager : AFHTTPClient

@property (nonatomic, strong) NSMutableArray* operations;
@property (nonatomic, strong) NSMutableArray* fetchedStories;
@property (nonatomic, strong) NSMutableArray* fetchedHackerNewsStories;
@property (nonatomic, strong) NSMutableArray* fetchedProggitStories;

+ (JSONManager *)sharedJSONManager;
- (void) executeOperations;
@end
