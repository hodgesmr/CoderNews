//
//  BaseViewController.m
//  CoderNews (https://github.com/hodgesmr/CoderNews)
//
//  Created by Matt Hodges on 3/3/13.
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
    if (self.menu.isOpen) {
        return [self.menu close];
    }
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"News"
                                                       image:[UIImage imageNamed:@"homeIcon"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          if(self.visibleTag != HOME_TAG) {
                                                              [self.navigationController popToRootViewControllerAnimated:NO];
                                                          }
                                                          self.visibleTag = HOME_TAG;
                                                      }];
    
    REMenuItem *aboutItem = [[REMenuItem alloc] initWithTitle:@"About"
                                                          image:[UIImage imageNamed:@"aboutIcon"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             if(self.visibleTag != ABOUT_TAG) {
                                                                 [self.rootViewControllerDelegate pushToAbout];
                                                             }
                                                             self.visibleTag = ABOUT_TAG;
                                                         }];
    
    REMenuItem *privacyItem = [[REMenuItem alloc] initWithTitle:@"Privacy"
                                                           image:[UIImage imageNamed:@"privacyIcon"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              if(self.visibleTag != PRIVACY_TAG) {
                                                                  [self.rootViewControllerDelegate pushToPrivacy];
                                                              }
                                                              self.visibleTag = PRIVACY_TAG;
                                                          }];
    
    REMenuItem *settingsItem = [[REMenuItem alloc] initWithTitle:@"Settings"
                                                          image:[UIImage imageNamed:@"settingsIcon"]
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
    self.menu.cornerRadius = 0;
    self.menu.shadowColor = [UIColor blackColor];
    self.menu.shadowOffset = CGSizeMake(0, 1);
    self.menu.shadowOpacity = 1;
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.font = [UIFont fontWithName:@"HelveticaNeue" size:21.0];
    self.menu.textShadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.menu.textColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    [self.menu showFromNavigationController:self.navigationController];
}

@end
