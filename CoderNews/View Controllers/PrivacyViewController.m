//
//  PrivacyViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "PrivacyViewController.h"

@interface PrivacyViewController ()

@end

@implementation PrivacyViewController

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
    self.title = @"Privacy";
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.visibleTag = PRIVACY_TAG;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
