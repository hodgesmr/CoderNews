//
//  FetchedStory.h
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchedStory : NSObject

@property (nonatomic, weak) NSString* title;
@property (nonatomic, weak) NSString* url;
@property (nonatomic, weak) NSString* source;

@end
