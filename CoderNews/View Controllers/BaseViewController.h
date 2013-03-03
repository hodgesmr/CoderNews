//
//  BaseViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface BaseViewController : UIViewController
@property (strong, nonatomic) REMenu *menu;


- (void) showMenu;

@end
