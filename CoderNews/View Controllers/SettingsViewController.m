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
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu_Icon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.title = @"Settings";
    self.tbl.backgroundView = nil;
    self.tbl.backgroundColor = [UIColor clearColor];
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

#pragma mark - UITableViewDataSource methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
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

# pragma mark - Switch responders
- (void) toggleRequiresHackerNews:(id)sender {
    [[PreferencesManager sharedPreferencesManager] setRequiresHackerNews:[sender isOn]];
}

- (void) toggleRequiresProggit:(id)sender {
    [[PreferencesManager sharedPreferencesManager] setRequiresProggit:[sender isOn]];
}

- (void) toggleRequiresSound:(id)sender {
    [[PreferencesManager sharedPreferencesManager] setRequiresSound:[sender isOn]];
}

@end
