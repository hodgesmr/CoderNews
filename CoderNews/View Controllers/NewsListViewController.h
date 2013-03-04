//
//  NewsListViewController.h
//  CoderNews
//
//  Created by Matt Hodges on 2/2/13.
//  Copyright (c) 2013 Matt Hodges. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewsListViewController : BaseViewController <NSFetchedResultsControllerDelegate, RootViewControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) IBOutlet UITableView *newsTableView;
@end
