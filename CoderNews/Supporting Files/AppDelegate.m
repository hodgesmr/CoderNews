//
//  AppDelegate.m
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "Keys.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "NewsListViewController.h"
#import "PocketAPI.h"
#import "PreferencesManager.h"
#import "StoryInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // preferences
    NSDictionary* defaultPreferences = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], REQUIRES_HACKER_NEWS,
                                        [NSNumber numberWithBool:YES], REQUIRES_PROGGIT,
                                        [NSNumber numberWithBool:YES], REQUIRES_SOUND,
                                        [NSNumber numberWithInt:2], STORY_LIFETIME,
                                        nil];
    [[PreferencesManager sharedPreferencesManager] registerDefaults:defaultPreferences];
    
    // set up the appearance
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:21.0], UITextAttributeFont, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbarBackground"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    UIImage *toolbarBackgroundImage = [UIImage imageNamed:@"toolbarBackground"];
    [[UIToolbar appearance] setBackgroundImage:toolbarBackgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    // Pocket
    [[PocketAPI sharedAPI] setConsumerKey:POCKET_API_KEY];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // May want to implement this later...
}

- (BOOL) application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation{
    
    if([[PocketAPI sharedAPI] handleOpenURL:url]) {
        return YES;
    }
    else {
        // if you handle your own custom url-schemes, do it here
        return NO;
    }
}

@end
