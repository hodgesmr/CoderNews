//
//  BaseViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    // Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
    //
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"News"
                                                       image:[UIImage imageNamed:@"Home_Icon"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if(self.visibleTag != HOME_TAG) {
                                                              [self.navigationController popToRootViewControllerAnimated:NO];
                                                          }
                                                          self.visibleTag = HOME_TAG;
                                                      }];
    
    REMenuItem *aboutItem = [[REMenuItem alloc] initWithTitle:@"About"
                                                          image:[UIImage imageNamed:@"About_Icon"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             if(self.visibleTag != ABOUT_TAG) {
                                                                 AboutViewController* avc = [[AboutViewController alloc] init];
                                                                 [self.navigationController popToRootViewControllerAnimated:NO];
                                                                 [self.navigationController pushViewController:avc animated:NO];
                                                             }
                                                             self.visibleTag = ABOUT_TAG;
                                                         }];
    
    REMenuItem *privacyItem = [[REMenuItem alloc] initWithTitle:@"Privacy"
                                                           image:[UIImage imageNamed:@"Privacy_Icon"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                          }];
    
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                          image:[UIImage imageNamed:@"Settings_Icon"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    homeItem.tag = HOME_TAG;
    aboutItem.tag = ABOUT_TAG;
    privacyItem.tag = PRIVACY_TAG;
    settingsItem.tag = SETTING_TAG;
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, aboutItem, privacyItem, settingsItem]];
    self.menu.cornerRadius = 4;
    self.menu.shadowColor = [UIColor blackColor];
    self.menu.shadowOffset = CGSizeMake(0, 1);
    self.menu.shadowOpacity = 1;
    self.menu.imageOffset = CGSizeMake(5, -1);
    
    [self.menu showFromNavigationController:self.navigationController];
}

@end
