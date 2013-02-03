//
//  ContentViewController.m
//  CoderNews
//
//  Created by hodgesmr on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

@synthesize storyTitle;
@synthesize storyUrl;
@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = storyTitle;
    NSURL* url = [[NSURL alloc] initWithString:self.storyUrl];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
