//
//  ContentViewController.m
//  CoderNews (https://github.com/hodgesmr/CoderNews)
//
//  Created by Matt Hodges on 2/2/13.
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

#import "ContentViewController.h"
#import "CustomAlertView.h"
#import "PocketAPI.h"

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
    
    [self.toolbar setTintColor:[UIColor whiteColor]];
    
    self.toolbar.items = toolbarItems;
    self.webView.delegate = self;
    self.title = storyTitle;
    @try {
        NSURL* url = [[NSURL alloc] initWithString:self.storyUrl];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
    @catch (NSException* e) {
        // If something screwed up, no controls
        self.refreshButton.enabled = NO;
        self.shareButton.enabled = NO;
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Web View

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateButtonsWithStop:YES];
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    if( [url.host hasSuffix:@"itunes.apple.com"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: request.URL.absoluteString]];
        return NO;
    }
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

# pragma mark - Toobar

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
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
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
        [self showActionSheet:sender];
    }
}

# pragma mark - UIActionSheet

- (void)showActionSheet:(id)sender {
    NSString *other1 = @"Copy URL";
    NSString *other2 = @"Open in Safari";
    NSString *other3 = @"Read Later";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3, nil];
    actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
    if(buttonIndex == 0) { // copy to clipboard
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.webView.request.URL.absoluteString;
    }
    else if(buttonIndex == 1) { // open in Safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.webView.request.URL.absoluteString]];
    }
    else if(buttonIndex == 2) { // read later functionality
        NSURL *url = [NSURL URLWithString:self.webView.request.URL.absoluteString];
        [[PocketAPI sharedAPI] saveURL:url handler: ^(PocketAPI *API, NSURL *URL, NSError *error){
            if(error) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:@"There was an error adding the story to your Pocket account."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"OK",nil];
                [alertView show];
                
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Saved"
                                                                                  message:@"The story was added to your Pocket account."
                                                                                 delegate:nil
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"OK",nil];
                [alertView show];
            }
        }];
    }
}


@end
