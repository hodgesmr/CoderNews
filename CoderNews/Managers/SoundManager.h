//
//  SoundManager.h
//  CoderNews
//
//  Created by Matt Hodges on 3/16/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundManager : NSObject {
	SystemSoundID _soundObject;
	
}

+ (SoundManager *)sharedSoundManager;
- (void) playSoundWithName:(NSString*)name andExtension:(NSString*)extension;

@end
