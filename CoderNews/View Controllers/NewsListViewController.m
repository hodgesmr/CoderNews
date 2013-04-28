//
//  NewsListViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AboutViewController.h"
#import "ContentViewController.h"
#import "CoreDataManager.h"
#import "NewsListViewController.h"
#import "PreferencesManager.h"
#import "PrivacyViewController.h"
#import "SettingsViewController.h"

@interface NewsListViewController () <CoreDataDelegate>

@end

@implementation NewsListViewController {
    NSIndexPath* currentlySelected;
    UIRefreshControl* refreshControl;
}

@synthesize fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Coder News";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuIcon.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.rootViewControllerDelegate = self;
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = @"Pull to refresh";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0]}];
    refreshControl.tintColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:52/255.0 alpha:1];
    
    [self.newsTableView addSubview: refreshControl];
    self.newsTableView.separatorColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:0.7];
    
    self.fetchedResultsController = [[CoreDataManager sharedManager] fetchStoryInfosById];
    [self refreshFeed];
    [[CoreDataManager sharedManager] setDelegate:self];
    [self checkForNewData];
}

- (void) checkForNewData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[CoreDataManager sharedManager] fetchNewDataFromNetwork];
}

- (void) viewDidDisappear:(BOOL)animated {
    currentlySelected = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshFeed];
    self.visibleTag = HOME_TAG;
}

- (void) viewDidUnload {
    self.fetchedResultsController = nil;
    self.fetchedResultsController.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
    [self checkForNewData];
}

-(void) refreshFeed {
    NSError* error;
    if(![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1); // do I really want to do this?
    }
    [self.newsTableView reloadData];
    
    // Stop refresh control
    [refreshControl endRefreshing];
}

- (NSString*) stripWWWFromURL:(NSString*)urlString {
    NSString* wwwString = [[urlString substringToIndex:4] lowercaseString];
    if([wwwString isEqualToString:@"www."]) {
        return [urlString substringWithRange:NSMakeRange(4, urlString.length-4)];
    }
    return urlString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"contentSegue"]) {
        ContentViewController *contentViewController = (ContentViewController *)segue.destinationViewController;
        StoryInfo* si = [self.fetchedResultsController objectAtIndexPath:currentlySelected];
        contentViewController.storyTitle = si.title;
        contentViewController.storyUrl = si.url;
        [[CoreDataManager sharedManager] setUrlVisited:si.url];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: NSLocalizedString(@"News", nil)
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
        [[SoundManager sharedSoundManager] playSoundWithName:@"oneClick" andExtension:@"wav"];
    }
}

#pragma mark = RootViewControllerDelegate
-(void)pushToAbout {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIStoryboard *storyboard = [self storyboard];
    AboutViewController *avc = [storyboard instantiateViewControllerWithIdentifier:@"AboutScreen"];
    avc.rootViewControllerDelegate = self;
    [self.navigationController pushViewController:avc animated:NO];
}

-(void)pushToPrivacy {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIStoryboard *storyboard = [self storyboard];
    PrivacyViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"PrivacyScreen"];
    pvc.rootViewControllerDelegate = self;
    [self.navigationController pushViewController:pvc animated:NO];
}

-(void)pushToSettings {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIStoryboard *storyboard = [self storyboard];
    SettingsViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsScreen"];
    svc.rootViewControllerDelegate = self;
    [self.navigationController pushViewController:svc animated:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    StoryInfo *info = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAttributedString* asTitle = [[NSAttributedString alloc] initWithString:info.title];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.attributedText = asTitle;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    UIImageView *ribbonView = nil;
    
    // this is a gross hack to make sure we only add the ribbon once.
    for ( UIView *childView in cell.subviews ) {
        if([childView isKindOfClass:[UIImageView class]]) {
           ribbonView = (UIImageView*)childView;
        }
    }
    if(ribbonView == nil) {
        UIImage *ribbon = [UIImage imageNamed:@"ribbon.png"];
        ribbonView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [ribbonView setImage:ribbon];
        [cell addSubview:ribbonView];
    }
    // end gross
    
    if([[NSNumber numberWithBool:NO] isEqualToNumber:info.visited]) {
        cell.textLabel.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];
        ribbonView.hidden = NO;
    }
    else {
        cell.textLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:0.7];
        ribbonView.hidden = YES;
    }
    NSString* urlString = info.url;
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* domain = [self stripWWWFromURL:[url host]];
    NSAttributedString* asDetails = [[NSAttributedString alloc] initWithString:domain];
    cell.detailTextLabel.numberOfLines = 1;
    cell.detailTextLabel.attributedText = asDetails;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryInfo *info = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString* urlString = info.url;
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* domain = [self stripWWWFromURL:[url host]];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //Calculate the expected size based on the font and linebreak mode of the label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX); // this 280 came from experimentation.
    
    CGSize titleSize = [info.title sizeWithFont:cell.textLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.textLabel.lineBreakMode];
    CGSize detailSize = [domain sizeWithFont:cell.detailTextLabel.font constrainedToSize:maximumLabelSize lineBreakMode:cell.detailTextLabel.lineBreakMode];
    
    return titleSize.height + detailSize.height + 10; // woop, hard code
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentlySelected = indexPath;
    [self performSegueWithIdentifier:@"contentSegue" sender:self];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.newsTableView beginUpdates];
}

#pragma mark - fetchedResultsController
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.newsTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.newsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.newsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.newsTableView endUpdates];
}

#pragma mark - CoreDataDelegate

-(void)newDataAvailable {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[CoreDataManager sharedManager] deleteStoriesOlderThanDays:[[PreferencesManager sharedPreferencesManager] storyLifetime]];
    [self refreshFeed];
}

@end
