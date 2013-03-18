//
//  PreferencesManager.h
//  CoderNews
//
//  Created by Matt Hodges on 3/17/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQUIRES_HACKER_NEWS @"requiresHackerNews"
#define REQUIRES_PROGGIT @"requiresProggit"
#define REQUIRES_SOUND @"requiresSound"
#define STORY_LIFETIME @"storyLifetime"

@interface PreferencesManager : NSObject

+ (PreferencesManager *) sharedPreferencesManager;

- (BOOL) requiresHackerNews;
- (BOOL) requiresProggit;
- (BOOL) requiresSound;
- (int) storyLifetime;

- (void) setRequiresHackerNews:(BOOL)requiresHackerNews;
- (void) setRequiresProggit:(BOOL)requiresProggit;
- (void) setRequiresSound:(BOOL)requiresSound;
- (void) setStoryLifetime:(int)storyLifetime;

- (void) registerDefaults:(NSDictionary*)defaultPreferences;

@end
