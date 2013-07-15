//
//  AboutViewController.m
//  CoderNews (https://github.com/hodgesmr/CoderNews)
//
//  Created by Matt Hodges on 2/3/13.
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
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.title = @"About";
    self.versionNumberLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:220.0/255.0 alpha:1.0];
    [[self followButton] setBackgroundColor:[UIColor darkGrayColor]];
    [[self followButton] setTitle:@"Follow @hodgesmr" forState:UIControlStateNormal];
    [[self forkButton] setBackgroundColor:[UIColor darkGrayColor]];
    [[self forkButton] setTitle:@"Fork Me!" forState:UIControlStateNormal];
    [[self contactButton] setBackgroundColor:[UIColor darkGrayColor]];
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
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
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

- (IBAction)forkTap:(id)sender {
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/hodgesmr/CoderNews"]];
}

- (IBAction)contactTap:(id)sender {
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSArray *toRecipients = [NSArray arrayWithObjects:@"hodgesmr1@gmail.com", nil];
        [mailer setToRecipients:toRecipients];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"Your device is not set up to send email."
                                                                         delegate:nil
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:@"OK",nil];
        [alertView show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
