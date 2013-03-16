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
    // we don't actually want the stop button in there yet
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[self.toolbar items]];
    [toolbarItems removeObject:self.stopButton];
    
    [self.toolbar setTintColor:[UIColor darkGrayColor]];
    
    self.toolbar.items = toolbarItems;
    self.webView.delegate = self;
    self.title = storyTitle;
    NSURL* url = [[NSURL alloc] initWithString:self.storyUrl];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SoundManager sharedSoundManager] playSoundWithName:@"click-open" andExtension:@"wav"];
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


- (IBAction)toolbarAction:(id)sender {
    [[SoundManager sharedSoundManager] playSoundWithName:@"click-open" andExtension:@"wav"];
    if(sender == self.backButton) {
        [self.webView goBack];
    }
    else if(sender == self.forwardButton) {
        [self.webView goForward];
    }
    else if(sender == self.refreshButton) {
        [self.webView reload];
    }
    else if(sender == self.stopButton) {
        [self.webView stopLoading];
    }
    else if(sender == self.shareButton) {
        // TODO
    }
}
@end
