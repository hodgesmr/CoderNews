//
//  PreferencesManager.m
//  CoderNews (https://github.com/hodgesmr/CoderNews)
//
//  Created by Matt Hodges on 3/17/13.
//  Copyright (c) 2013 Matt Hodges (http://matthodges.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
    return [defaults integerForKey:STORY_LIFETIME];
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

- (void) registerDefaults:(NSDictionary*)defaultPreferences {
    [defaults registerDefaults:defaultPreferences];
    [self populateCache];
}

# pragma mark - private methods

- (void) cacheValue:(id)value forKey:(NSString*)key {
    if(preferencesCache == nil) {
        preferencesCache = [[NSMutableDictionary alloc] init];
    }
    [preferencesCache setObject:value forKey:key];
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

@end
