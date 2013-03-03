//
//  BaseViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
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
                                                          [self.navigationController popToRootViewControllerAnimated:NO];
                                                      }];
    
    REMenuItem *aboutItem = [[REMenuItem alloc] initWithTitle:@"About"
                                                          image:[UIImage imageNamed:@"About_Icon"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self.navigationController popToRootViewControllerAnimated:NO];
                                                             [self performSegueWithIdentifier:@"aboutSegue" sender:nil];
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
    
    homeItem.tag = 0;
    aboutItem.tag = 1;
    privacyItem.tag = 2;
    settingsItem.tag = 3;
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, aboutItem, privacyItem, settingsItem]];
    self.menu.cornerRadius = 4;
    self.menu.shadowColor = [UIColor blackColor];
    self.menu.shadowOffset = CGSizeMake(0, 1);
    self.menu.shadowOpacity = 1;
    self.menu.imageOffset = CGSizeMake(5, -1);
    
    [self.menu showFromNavigationController:self.navigationController];
}

@end
