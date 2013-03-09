//
//  ContentViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController {
}

@synthesize storyTitle;
@synthesize storyUrl;
@synthesize webView = _webView;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize refreshButton =_refreshButton;
@synthesize shareButton = _shareButton;
@synthesize stopButton = _stopButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.toolbar items]];
    // we don't actually want the stop button in there yet
    [toolbarItems removeObject:self.stopButton];
    self.toolbar.items = toolbarItems;
    self.webView.delegate = self;
    self.title = storyTitle;
    NSURL* url = [[NSURL alloc] initWithString:self.storyUrl];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateButtonsWithStop:YES];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self updateButtonsWithStop:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtonsWithStop:NO];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtonsWithStop:NO];
}

- (void)updateButtonsWithStop:(BOOL)hasStop {
    self.forwardButton.enabled = self.webView.canGoForward;
    self.backButton.enabled = self.webView.canGoBack;
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.toolbar items]];
    if(hasStop) {
        [toolbarItems replaceObjectAtIndex:4 withObject:self.stopButton];
        self.toolbar.items = toolbarItems;
    }
    else {
        [toolbarItems replaceObjectAtIndex:4 withObject:self.refreshButton];
        self.toolbar.items = toolbarItems;
    }
    
    
}

@end
