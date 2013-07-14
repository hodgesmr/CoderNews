//
//  NewsListViewController.m
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

#import "AboutViewController.h"
#import "ContentViewController.h"
#import "CoreDataManager.h"
#import "NewsListViewController.h"
#import "NSString+HTML.h"
#import "PreferencesManager.h"
#import "PrivacyViewController.h"
#import "SettingsViewController.h"
#import "UIView+Toast.h"

@interface NewsListViewController () <CoreDataDelegate> {
    NSDecimalNumber* oldUid;
}

@end

@implementation NewsListViewController {
    NSIndexPath* currentlySelected;
    UIRefreshControl* refreshControl;
    UIFont* visitedFont;
    UIFont* notVisitedFont;
    UIFont* domainFont;
}

@synthesize fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CoderNews";
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForNewData) name:@"applicationDidBecomeActive" object:nil];
    oldUid = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    visitedFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    notVisitedFont = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    domainFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
}

- (void) checkForNewData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    oldUid = [NSDecimalNumber decimalNumberWithString:[[[CoreDataManager sharedManager] getLastUid] stringValue]];
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
    if(urlString.length > 4) {
        NSString* wwwString = [[urlString substringToIndex:4] lowercaseString];
        if([wwwString isEqualToString:@"www."]) {
            return [urlString substringWithRange:NSMakeRange(4, urlString.length-4)];
        }
    }
    return urlString;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"contentSegue"]) {
        ContentViewController *contentViewController = (ContentViewController *)segue.destinationViewController;
        StoryInfo* si = [self.fetchedResultsController objectAtIndexPath:currentlySelected];
        contentViewController.storyTitle = si.title;
        contentViewController.storyUrl = [si.url stringByDecodingHTMLEntities]; // deal with any shit data that got in
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // set up the cell...
    StoryInfo *info = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSAttributedString* asTitle = [[NSAttributedString alloc] initWithString:info.title];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.attributedText = asTitle;
    cell.textLabel.font = notVisitedFont;
    
    if([[NSNumber numberWithBool:NO] isEqualToNumber:info.visited]) {
        cell.textLabel.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];
    }
    else {
        cell.textLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:0.7];
        cell.textLabel.font = visitedFont;
    }
    
    NSString* urlString = [info.url stringByDecodingHTMLEntities]; // decode any shit data that got in
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* domain = [self stripWWWFromURL:[url host]];
    NSAttributedString* asDetails;
    if(domain != nil) {
        asDetails = [[NSAttributedString alloc] initWithString:domain];
    }
    else {
        asDetails = [[NSAttributedString alloc] initWithString:info.url];
    }
    cell.detailTextLabel.numberOfLines = 1;
    cell.detailTextLabel.attributedText = asDetails;
    cell.detailTextLabel.font = domainFont;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoryInfo *info = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString* urlString = [info.url stringByDecodingHTMLEntities]; // decode any shit data that got in
    NSURL* url = [NSURL URLWithString:urlString];
    NSString* domain = [self stripWWWFromURL:[url host]];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CGSize maximumLabelSize = CGSizeMake(265, FLT_MAX);
    UIFont* labelFont;
    if([[NSNumber numberWithBool:NO] isEqualToNumber:info.visited]) {
        labelFont = notVisitedFont;
    }
    else {
        labelFont = visitedFont;
    }
    CGSize titleSize = [info.title sizeWithFont:labelFont constrainedToSize:maximumLabelSize lineBreakMode:cell.textLabel.lineBreakMode];
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
            [tableView cellForRowAtIndexPath:indexPath];
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
    NSDecimalNumber* newUid = [NSDecimalNumber decimalNumberWithString:[[[CoreDataManager sharedManager] getLastUid] stringValue]];
    NSString* diff = [[newUid decimalNumberBySubtracting:oldUid] stringValue];
    if(![diff isEqualToString:@"0"]) {
        NSString* message;
        if([diff isEqualToString:@"1"]) {
            message = [NSString stringWithFormat:@"%@%@", diff, @" new story"];
        }
        else {
            message = [NSString stringWithFormat:@"%@%@", diff, @" new stories"];
        }
        [self.view makeToast:message];
    }
    [self refreshFeed];
}

@end
