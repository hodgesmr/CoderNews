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
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
