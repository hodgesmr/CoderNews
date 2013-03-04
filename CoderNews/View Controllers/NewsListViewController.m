//
//  MasterViewController.m
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import "AboutViewController.h"
#import "ContentViewController.h"
#import "CoreDataManager.h"
#import "NewsListViewController.h"

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = @"Pull to refresh";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0]}];
    
    [self.newsTableView addSubview: refreshControl];
    
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
    }
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
    if([[NSNumber numberWithBool:YES] isEqualToNumber:info.visited]) {
        cell.textLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    }
    else {
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    
    NSString* urlString = info.url;
    NSURL* url = [NSURL URLWithString:urlString];
    NSAttributedString* asDetails = [[NSAttributedString alloc] initWithString:[url host]];
    cell.detailTextLabel.numberOfLines = 1;
    cell.detailTextLabel.attributedText = asDetails;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryInfo *info = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString* urlString = info.url;
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* domain = [url host];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //Calculate the expected size based on the font and linebreak mode of the label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX); // this 270 came from experimentation.
    
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
    [[CoreDataManager sharedManager] deleteStoriesOlderThanDays:2];
    [self refreshFeed];
}

@end
