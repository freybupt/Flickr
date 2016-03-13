//
//  SearchHistoryController.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoSearchResult;

@interface SearchHistoryController : NSObject

- (void)saveSearchHistoryWithSearchTerm:(NSString *)text
                                results:(PhotoSearchResult *)searchResult;
- (NSDictionary *)retrieveAllSearchHistory;

@end
