//
//  MasterViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultsController;

@end
