//
//  BaseViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

#define HOME_TAG 1
#define ABOUT_TAG 2
#define PRIVACY_TAG 3
#define SETTING_TAG 4

@interface BaseViewController : UIViewController
@property (strong, nonatomic) REMenu *menu;
@property int visibleTag;


- (void) showMenu;

@end
