//
//  PreferencesManager.m
//  CoderNews
//
//  Created by Matt Hodges on 3/17/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "PreferencesManager.h"

@implementation PreferencesManager {
    NSUserDefaults* defaults;
}

static PreferencesManager* _sharedPreferencesManagerInstance;
static NSMutableDictionary* preferencesCache = nil;

+ (PreferencesManager *) sharedPreferencesManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPreferencesManagerInstance = [[PreferencesManager alloc] init];
    });
    return _sharedPreferencesManagerInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) populateCache {
    [self cacheValue:[NSNumber numberWithBool:[self requiresHackerNews]] forKey:REQUIRES_HACKER_NEWS];
    [self cacheValue:[NSNumber numberWithBool:[self requiresProggit]] forKey:REQUIRES_PROGGIT];
    [self cacheValue:[NSNumber numberWithBool:[self requiresSound]] forKey:REQUIRES_SOUND];
    [self cacheValue:[NSNumber numberWithInt:[self storyLifetime]] forKey:STORY_LIFETIME];
}

- (void) clearCache {
    preferencesCache = nil;
}

- (BOOL) requiresHackerNews {
    if([preferencesCache objectForKey:REQUIRES_HACKER_NEWS]) {
        return [[preferencesCache objectForKey:REQUIRES_HACKER_NEWS] boolValue];
    }
    return [defaults boolForKey:REQUIRES_HACKER_NEWS];
}

- (BOOL) requiresProggit {
    if([preferencesCache objectForKey:REQUIRES_PROGGIT]) {
        return [[preferencesCache objectForKey:REQUIRES_PROGGIT] boolValue];
    }
    return [defaults boolForKey:REQUIRES_PROGGIT];
}

- (BOOL) requiresSound {
    if([preferencesCache objectForKey:REQUIRES_SOUND]) {
        return [[preferencesCache objectForKey:REQUIRES_SOUND] boolValue];
    }
    return [defaults boolForKey:REQUIRES_SOUND];
}

- (int) storyLifetime {
    if([preferencesCache objectForKey:STORY_LIFETIME]) {
        return [[preferencesCache objectForKey:STORY_LIFETIME] intValue];
    }
    return [defaults boolForKey:STORY_LIFETIME];
}

- (void) setRequiresHackerNews:(BOOL)requiresHackerNews {
    [defaults setBool:requiresHackerNews forKey:REQUIRES_HACKER_NEWS];
    [self cacheValue:[NSNumber numberWithBool:requiresHackerNews] forKey:REQUIRES_HACKER_NEWS];
}

- (void) setRequiresProggit:(BOOL)requiresProggit {
    [defaults setBool:requiresProggit forKey:REQUIRES_PROGGIT];
    [self cacheValue:[NSNumber numberWithBool:requiresProggit] forKey:REQUIRES_PROGGIT];
}

- (void) setRequiresSound:(BOOL)requiresSound {
    [defaults setBool:requiresSound forKey:REQUIRES_SOUND];
    [self cacheValue:[NSNumber numberWithBool:requiresSound] forKey:REQUIRES_SOUND];
}

- (void) setStoryLifetime:(int)storyLifetime {
    [defaults setInteger:storyLifetime forKey:STORY_LIFETIME];
    [self cacheValue:[NSNumber numberWithInt:storyLifetime] forKey:STORY_LIFETIME];
}

# pragma mark - private methods

- (void) cacheValue:(id)value forKey:(NSString*)key {
    if(preferencesCache == nil) {
        preferencesCache = [[NSMutableDictionary alloc] init];
    }
    [preferencesCache setObject:value forKey:key];
}

@end
