//
//  SoundManager.m
//  CoderNews
//
//  Created by Matt Hodges on 3/16/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "PreferencesManager.h"
#import "SoundManager.h"

static SoundManager*_sharedSoundManagerInsance;

@implementation SoundManager

+ (SoundManager *) sharedSoundManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSoundManagerInsance = [[SoundManager alloc] init];
    });
    return _sharedSoundManagerInsance;
}

- (void) playSoundWithName:(NSString*)name andExtension:(NSString*)extension {
    if([[PreferencesManager sharedPreferencesManager] requiresSound]) {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:extension];
        NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &_soundObject);
        AudioServicesPlaySystemSound(_soundObject);
    }
}

@end
