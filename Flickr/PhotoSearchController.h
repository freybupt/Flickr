//
//  PhotoSearchController.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoSearchResult;

@protocol PhotoUpdateControllerDelegate <NSObject>

@required
- (void)updateWithSearchResult:(PhotoSearchResult *)searchResult;
- (void)showLoadingStatus:(BOOL)showLoading withMessage:(NSString *)loadingMessage;
- (void)flushAllResults;

@end

@protocol PhotoHistoryControllerDelegate <NSObject>

@required
- (void)updateWithSearchHistory:(NSDictionary *)historyDictionary;

@end

@interface PhotoSearchController : UISearchController

@property (nonatomic, weak) id <PhotoUpdateControllerDelegate> photoUpdateDelegate;
@property (nonatomic, weak) id <PhotoHistoryControllerDelegate> searchHistoryDelegate;

@property (nonatomic, copy) void (^searchStatusChangeHandler)(BOOL);

- (void)didChangeSearchText:(NSString *)text;


@end
