//
//  FetchedStory.h
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchedStory : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* source;
@property (nonatomic, strong) NSDecimalNumber* score;

@end
