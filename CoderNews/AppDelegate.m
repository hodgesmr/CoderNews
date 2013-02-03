//
//  AppDelegate.m
//  CoderNews
//
//  Created by hodgesmr on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataManager.h"
#import "MasterViewController.h"
#import "StoryInfo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Test insert
    NSManagedObjectContext* context = [[CoreDataManager sharedManager] managedObjectContext];
    StoryInfo* storyInfo = [NSEntityDescription insertNewObjectForEntityForName:@"StoryInfo" inManagedObjectContext:context];
    storyInfo.title = @"An awesome title";
    storyInfo.url = @"http://google.com";
    storyInfo.source = @"hackernews";
    storyInfo.visited = [NSNumber numberWithBool:NO];
    NSError* error;
    if(![context save:&error]) {
        NSLog(@"Whoops, couldn't save : %@", [error localizedDescription]);
    }
    // Test read
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"StoryInfo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for(StoryInfo* info in fetchedObjects) {
        NSLog(@"Title: %@ Url: %@ Source: %@ Visited: %s",info.title ,info.url,info.source,(info.visited ? "true" : "false"));
    }
    
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = [[CoreDataManager sharedManager] managedObjectContext];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedManager] managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

@end
