//
//  HistoryTableViewController.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryTableViewCell.h"

static NSString *historyCellIdentifier = @"historyCellIdentifier";

@interface HistoryTableViewController ()

@property (nonatomic, strong) NSDictionary *searchHistoryDictionary; // key:search text, value:number of results

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchHistoryDictionary = [NSDictionary new];
}

#pragma mark - <PhotoHistoryControllerDelegate>

- (void)updateWithSearchHistory:(NSDictionary *)historyDictionary
{
    if (!historyDictionary) {
        return;
    }
    
    self.searchHistoryDictionary = historyDictionary;
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchHistoryDictionary.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",
                            self.searchHistoryDictionary.allKeys[indexPath.row]];
    cell.subtitleLabel.text = [NSString stringWithFormat:@"%@ results", self.searchHistoryDictionary.allValues[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // restart search with history search term
    NSString *searchTerm = [NSString stringWithFormat:@"%@",
                            self.searchHistoryDictionary.allKeys[indexPath.row]];
    if (self.pickHistorySearchTermHandler && searchTerm) {
        self.pickHistorySearchTermHandler(searchTerm);
    }
}


@end
