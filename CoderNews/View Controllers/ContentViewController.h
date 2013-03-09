//
//  ContentViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (nonatomic, weak) NSString* storyTitle;
@property (nonatomic, weak) NSString* storyUrl;
@property (nonatomic, weak) IBOutlet UIWebView* webView;
@property (nonatomic, weak) IBOutlet UIToolbar* toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;


@end
