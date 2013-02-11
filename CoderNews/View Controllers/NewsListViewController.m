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
@synthesize aboutButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Coder News";
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = @"Pull to refresh";
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    
    [self.tableView addSubview: refreshControl];
    
    self.fetchedResultsController = [[CoreDataManager sharedManager] fetchStoryInfosById];
    [self refreshFeed];
    [[CoreDataManager sharedManager] setDelegate:self];
    [self checkForNewData];
}

- (void) checkForNewData {
    [[CoreDataManager sharedManager] fetchNewDataFromNetwork];
}

- (void) viewDidDisappear:(BOOL)animated {
    currentlySelected = nil;
}

- (void) viewDidUnload {
    self.fetchedResultsController = nil; // Not sure if I want this or not...
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
    [self.tableView reloadData];
    
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
    }
}

- (IBAction)aboutTap:(id)sender {
    [self performSegueWithIdentifier:@"aboutSegue" sender:self];
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
    cell.textLabel.text = info.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", info.uid, info.source];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentlySelected = indexPath;
    [self performSegueWithIdentifier:@"contentSegue" sender:self];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

#pragma mark - fetchedResultsController
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark - CoreDataDelegate

-(void)newDataAvailable {
    [self refreshFeed];
}

@end
