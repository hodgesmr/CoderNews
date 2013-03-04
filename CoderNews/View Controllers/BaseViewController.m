//
//  BaseViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseViewController.h"
#import "PrivacyViewController.h"
#import "SettingsViewController.h"

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
                                                                 [self.rootViewControllerDelegate pushToAbout];
                                                             }
                                                             self.visibleTag = ABOUT_TAG;
                                                         }];
    
    REMenuItem *privacyItem = [[REMenuItem alloc] initWithTitle:@"Privacy"
                                                           image:[UIImage imageNamed:@"Privacy_Icon"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              if(self.visibleTag != PRIVACY_TAG) {
                                                                  [self.rootViewControllerDelegate pushToPrivacy];
                                                              }
                                                              self.visibleTag = PRIVACY_TAG;
                                                          }];
    
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                          image:[UIImage imageNamed:@"Settings_Icon"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             if(self.visibleTag != SETTINGS_TAG) {
                                                                 [self.rootViewControllerDelegate pushToSettings];
                                                             }
                                                             self.visibleTag = SETTINGS_TAG;
                                                         }];
    
    homeItem.tag = HOME_TAG;
    aboutItem.tag = ABOUT_TAG;
    privacyItem.tag = PRIVACY_TAG;
    settingsItem.tag = SETTINGS_TAG;
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, aboutItem, privacyItem, settingsItem]];
    self.menu.cornerRadius = 4;
    self.menu.shadowColor = [UIColor blackColor];
    self.menu.shadowOffset = CGSizeMake(0, 1);
    self.menu.shadowOpacity = 1;
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.font = [UIFont fontWithName:@"HelveticaNeue" size:21.0];
    self.menu.textShadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    self.menu.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    [self.menu showFromNavigationController:self.navigationController];
}

@end
