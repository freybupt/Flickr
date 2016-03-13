//
//  PhotoSearchController.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import "PhotoSearchController.h"
#import "FlickrSearchManager.h"
#import "SearchHistoryController.h"
#import "PhotoSearchResult.h"
#import "PhotoResult.h"

@interface PhotoSearchController () <UISearchBarDelegate>

@property (nonatomic, strong) SearchHistoryController *searchHistoryController;
@property (nonatomic, strong) NSString *currentSearchTerm;

@property (nonatomic, assign) BOOL isSearchHistoryActive;

@end

@implementation PhotoSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.hidesNavigationBarDuringPresentation = NO;
    self.dimsBackgroundDuringPresentation = NO;
    self.searchBar.showsSearchResultsButton = YES;
    self.searchBar.tintColor = [UIColor darkGrayColor];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = NSLocalizedString(@"Search on Flickr", nil);
    
    self.searchHistoryController = [[SearchHistoryController alloc] init];
}

- (void)didChangeSearchText:(NSString *)text
{
    [self.searchBar setText:text];
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    NSString *searchTerm = text;
    if (searchTerm.length == 0) {
        return;
    }
    
    [self showSearchHistory:NO];
    
    if (![searchTerm isEqualToString:self.currentSearchTerm]) {
        // start new search
        if (self.photoUpdateDelegate) {
            [self.photoUpdateDelegate showLoadingStatus:YES withMessage:nil];
            [self.photoUpdateDelegate flushAllResults];
        }
        [[FlickrSearchManager sharedManager] suspendSearch];
        self.currentSearchTerm = searchTerm;
        [self.photoUpdateDelegate updateWithSearchResult:nil];
        
        __typeof(self) __weak weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[FlickrSearchManager sharedManager] requestPhotoURLsWithSearchText:searchTerm completionHandler:^(PhotoSearchResult *searchResult, NSError *error) {
                
                // save search history when the first page returns
                if (searchResult && searchResult.pageIndex == 1) {
                    [weakSelf.searchHistoryController saveSearchHistoryWithSearchTerm:searchTerm results:searchResult];
                }
                
                // update photo UI on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.photoUpdateDelegate) {
                        [self.photoUpdateDelegate showLoadingStatus:NO withMessage:nil];
                        [weakSelf.photoUpdateDelegate updateWithSearchResult:searchResult];
                    }
                });
            }];
        });
    }
    else{
        // resume former search if search term is the same
        [[FlickrSearchManager sharedManager] resumeSearch];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self didChangeSearchText:searchBar.text];
}


- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    if (self.isSearchHistoryActive) {
        [self showSearchHistory:NO];
    }
    else{
        [self showSearchHistory:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.isSearchHistoryActive) {
        [self showSearchHistory:NO];
    }
}

- (void)showSearchHistory:(BOOL)showHistory
{
    if (showHistory) {
        NSDictionary *historyDict = [self.searchHistoryController retrieveAllSearchHistory];
        
        if (!historyDict) {
            return;
        }
        
        if (self.searchHistoryDelegate) {
            [self.searchHistoryDelegate updateWithSearchHistory:historyDict];
        }
        self.searchStatusChangeHandler(YES);
        self.isSearchHistoryActive = YES;
    }
    else{
        self.searchStatusChangeHandler(NO);
        self.isSearchHistoryActive = NO;
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    [[FlickrSearchManager sharedManager] suspendSearch];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0 ||
        [searchBar.text isEqualToString:self.currentSearchTerm]) {
        [[FlickrSearchManager sharedManager] resumeSearch];
    }
}

@end
