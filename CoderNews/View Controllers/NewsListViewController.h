//
//  MasterViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *aboutButton;
@property (strong, nonatomic) IBOutlet UITableView *newsTableView;
- (IBAction)aboutTap:(id)sender;
@end
