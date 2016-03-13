//
//  PhotoSearchResult.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSearchResult : NSObject

@property (nonatomic, strong, readonly) NSArray *photosArray;
@property (nonatomic, assign, readonly) NSInteger numberOfPhotosPerPage;
@property (nonatomic, assign, readonly) NSInteger totalPagesCount;
@property (nonatomic, assign, readonly) NSInteger totalPhotosCount;
@property (nonatomic, assign, readonly) NSInteger pageIndex;

- (instancetype) initWithDictionary:(NSDictionary*)searchResult;

@end
