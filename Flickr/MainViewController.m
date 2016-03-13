//
//  MainViewController.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "MainViewController.h"
#import "PhotoSearchController.h"
#import "PhotoCollectionViewController.h"
#import "HistoryTableViewController.h"

@interface MainViewController () 

@property (nonatomic, strong) PhotoSearchController *searchController;
@property (nonatomic, weak) PhotoCollectionViewController *photoCollectionViewController;
@property (nonatomic, weak) HistoryTableViewController *historyTableViewController;

@property (nonatomic, weak) IBOutlet UIView *photoCollectionContainerView;
@property (nonatomic, weak) IBOutlet UIView *historyTableContainerView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // init search controller - get search text and notify updates
    self.searchController = [[PhotoSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.photoUpdateDelegate = self.photoCollectionViewController;
    self.searchController.searchHistoryDelegate = self.historyTableViewController;
    self.navigationItem.titleView = self.searchController.searchBar;
    __typeof(self) __weak weakSelf = self;
    self.searchController.searchStatusChangeHandler = ^(BOOL shouldShowHistory){
        if (shouldShowHistory) {
            weakSelf.historyTableContainerView.hidden = NO;
        }
        else{
            weakSelf.historyTableContainerView.hidden = YES;
        }
    };
    
    // select history search terms will retrive search
    self.historyTableViewController.pickHistorySearchTermHandler = ^(NSString *historySearchTerm){
        [weakSelf.searchController didChangeSearchText:historySearchTerm];
    };
    self.historyTableContainerView.hidden = YES; // hide history at launch

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // get reference to photo collectionViewController and history tableviewController when storyboard is loaded
    if ([segue.destinationViewController isKindOfClass:[PhotoCollectionViewController class]]) {
        self.photoCollectionViewController = segue.destinationViewController;
    }
    
    if ([segue.destinationViewController isKindOfClass:[HistoryTableViewController class]]) {
        self.historyTableViewController = segue.destinationViewController;
    }
}


@end
