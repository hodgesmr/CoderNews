//
//  JSONManager.h
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AFHTTPClient.h"

@interface JSONManager : AFHTTPClient

@property (nonatomic, weak) NSMutableArray* operations;

+ (JSONManager *)sharedJSONManager;
- (void) enqueueOperations;
@end
