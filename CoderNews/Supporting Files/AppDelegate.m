//
//  AppDelegate.m
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "JSONManager.h"
#import "NewsListViewController.h"
#import "StoryInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Test insert
    [[CoreDataManager sharedManager] persistStoryWithTitle:@"Test Title" url:@"http://example.com" source:@"hackernews"];
    
    
    // Test JSON
    [[JSONManager sharedJSONManager] executeOperations];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // May want to implement this later...
}

@end
