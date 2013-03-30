//
//  AboutViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 2/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu_Icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.title = @"About";
    self.versionNumberLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [[self followButton] setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [[self followButton] setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [[self followButton] setTitle:@"Follow @hodgesmr" forState:UIControlStateNormal];
    [[self rateButton] setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [[self rateButton] setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [[self rateButton] setTitle:@"Rate App" forState:UIControlStateNormal];
    [[self contactButton] setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [[self contactButton] setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [[self contactButton] setTitle:@"Contact" forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.visibleTag = ABOUT_TAG;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)followTap:(id)sender {
    NSArray *urls = [NSArray arrayWithObjects:
                     @"twitter://user?screen_name=hodgesmr", // Twitter
                     @"tweetbot:///user_profile/hodgesmr", // TweetBot
                     @"echofon:///user_timeline?hodgesmr", // Echofon
                     @"twit:///user?screen_name=hodgesmr", // Twittelator Pro
                     @"x-seesmic://twitter_profile?twitter_screen_name=hodgesmr", // Seesmic
                     @"x-birdfeed://user?screen_name=hodgesmr", // Birdfeed
                     @"tweetings:///user?screen_name=hodgesmr", // Tweetings
                     @"simplytweet:?link=http://twitter.com/hodgesmr", // SimplyTweet
                     @"icebird://user?screen_name=hodgesmr", // IceBird
                     @"fluttr://user/hodgesmr", // Fluttr
                     @"http://twitter.com/hodgesmr",
                     nil];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    for (NSString *candidate in urls) {
        NSURL *url = [NSURL URLWithString:candidate];
        if ([application canOpenURL:url])
        {
            [application openURL:url];
            return;
        }
    }
}
@end
