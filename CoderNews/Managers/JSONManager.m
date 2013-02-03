//
//  JSONManager.m
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "JSONManager.h"

static NSString* const proggitUrl = @"http://www.reddit.com/r/programming/.json";
static NSString* const hackerNewsUrl = @"http://hndroidapi.appspot.com/news/format/json/page/?appid=Coder%20News";

@implementation JSONManager

+ (JSONManager *)sharedJSONManager {
    static JSONManager *sharedJSONManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedJSONManager = [[JSONManager alloc] initWithBaseURL:[NSURL URLWithString:proggitUrl]];
    });
    
    return sharedJSONManager;
}

@end
