//
//  HistoryTableViewController.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoSearchController.h"

@interface HistoryTableViewController : UITableViewController <PhotoHistoryControllerDelegate>

@property (nonatomic, copy) void (^pickHistorySearchTermHandler)(NSString *);

@end
