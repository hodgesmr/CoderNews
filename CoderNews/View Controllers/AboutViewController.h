//
//  AboutViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AboutViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *coderNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;

@end
