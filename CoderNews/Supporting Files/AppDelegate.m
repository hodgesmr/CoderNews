//
//  AppDelegate.m
//  CoderNews (https://github.com/hodgesmr/CoderNews)
//
//  Created by Matt Hodges on 2/2/13.
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

#import "Keys.h"
#import "AppDelegate.h"
#import "CoreDataManager.h"
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
                                        [NSNumber numberWithBool:NO], REQUIRES_SOUND,
                                        [NSNumber numberWithInt:2], STORY_LIFETIME,
                                        nil];
    [[PreferencesManager sharedPreferencesManager] registerDefaults:defaultPreferences];
    
    // set up the appearance
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-Medium" size:21.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
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
