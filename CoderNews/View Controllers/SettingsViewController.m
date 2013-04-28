//
//  SettingsViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 3/3/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "PreferencesManager.h"
#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize tbl;

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
    self.title = @"Settings";
    self.tbl.backgroundView = nil;
    self.tbl.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:220.0/255.0 alpha:1.0];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.visibleTag = SETTINGS_TAG;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return nil;
        }
        case 1:{
            
            UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl.frame.size.width, 100)];
            footerView.backgroundColor = [UIColor clearColor];
            [footerView setClipsToBounds:NO];
            [footerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            
            UILabel* cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake
                                    (20, 10, footerView.frame.size.width-30, 30)];
            cacheLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
            [cacheLabel setBackgroundColor:[UIColor clearColor]];
            [cacheLabel setShadowColor:[UIColor colorWithWhite:1 alpha:.75]];
            [cacheLabel setText:@"Days to keep stories:"];
            [footerView addSubview:cacheLabel];
            
            NSArray* cacheDays = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", nil];
            UISegmentedControl* cacheControl = [[UISegmentedControl alloc] initWithItems:cacheDays];
            cacheControl.segmentedControlStyle = UISegmentedControlStyleBar;
            cacheControl.tintColor = [UIColor grayColor];
            [cacheControl addTarget:self action:@selector(cacheSelection:) forControlEvents:UIControlEventValueChanged];
            cacheControl.frame = CGRectMake(10, 44, self.tbl.frame.size.width-20, 47);
            [cacheControl setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
            cacheControl.selectedSegmentIndex = [[PreferencesManager sharedPreferencesManager] storyLifetime]-1;
            [footerView addSubview:cacheControl];
            return footerView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // hackity hackity hackity
    switch (section) {
        case 0:
            return 0;
            break;
            
        case 1:
            return 100;
            break;
    }
    return 0;
}

#pragma mark - UITableViewDataSource methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchview setOnTintColor: [UIColor blackColor]];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Hacker News";
                [switchview setOn:[[PreferencesManager sharedPreferencesManager] requiresHackerNews]];
                [switchview addTarget:self action:@selector(toggleRequiresHackerNews:) forControlEvents:UIControlEventValueChanged];
                break;
            case 1:
                cell.textLabel.text = @"Reddit Programming";
                [switchview setOn:[[PreferencesManager sharedPreferencesManager] requiresProggit]];
                [switchview addTarget:self action:@selector(toggleRequiresProggit:) forControlEvents:UIControlEventValueChanged];
                break;
            default:
                break;
        }
    }
    else { // it's 1
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Sounds";
                [switchview setOn:[[PreferencesManager sharedPreferencesManager] requiresSound]];
                [switchview addTarget:self action:@selector(toggleRequiresSound:) forControlEvents:UIControlEventValueChanged];
                break;
            default:
                break;
        }
    }
    
    cell.accessoryView = switchview;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        default:
            return 0;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

# pragma mark - control responders
- (void) toggleRequiresHackerNews:(id)sender {
    [[PreferencesManager sharedPreferencesManager] setRequiresHackerNews:[sender isOn]];
    [[SoundManager sharedSoundManager] playSoundWithName:@"click-open" andExtension:@"wav"];
}

- (void) toggleRequiresProggit:(id)sender {
    [[PreferencesManager sharedPreferencesManager] setRequiresProggit:[sender isOn]];
    [[SoundManager sharedSoundManager] playSoundWithName:@"click-open" andExtension:@"wav"];
}

- (void) toggleRequiresSound:(id)sender {
    [[PreferencesManager sharedPreferencesManager] setRequiresSound:[sender isOn]];
    [[SoundManager sharedSoundManager] playSoundWithName:@"click-open" andExtension:@"wav"];
}

- (void) cacheSelection:(id)sender {
    [[SoundManager sharedSoundManager] playSoundWithName:@"click-open" andExtension:@"wav"];
    [[PreferencesManager sharedPreferencesManager] setStoryLifetime:[sender selectedSegmentIndex]+1];
}

@end
