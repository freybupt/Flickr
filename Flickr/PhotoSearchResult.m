//
//  PhotoSearchResult.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import "PhotoSearchResult.h"

@interface PhotoSearchResult ()

@property (nonatomic, strong, readwrite) NSArray *photosArray;
@property (nonatomic, assign, readwrite) NSInteger numberOfPhotosPerPage;
@property (nonatomic, assign, readwrite) NSInteger totalPagesCount;
@property (nonatomic, assign, readwrite) NSInteger totalPhotosCount;
@property (nonatomic, assign, readwrite) NSInteger pageIndex;

@end


@implementation PhotoSearchResult

- (instancetype)initWithDictionary:(NSDictionary *)searchResult
{
    if (self = [super init]) {
        
        id photosArray = searchResult[@"photo"];
        _photosArray = [photosArray isKindOfClass:[NSMutableArray class]] ? photosArray : nil;
//        NSAssert(_photosArray, @"Photo Array is nil!");
        
        id numberOfPhotosPerPage = searchResult[@"perpage"];
        _numberOfPhotosPerPage = [numberOfPhotosPerPage respondsToSelector:@selector(integerValue)] ? [numberOfPhotosPerPage integerValue] : -1;
        
        id totalPagesCount = searchResult[@"pages"];
        _totalPagesCount = [totalPagesCount respondsToSelector:@selector(integerValue)] ? [totalPagesCount integerValue] : -1;
        
        id totalPhotosCount = searchResult[@"total"];
        _totalPhotosCount = [totalPhotosCount respondsToSelector:@selector(integerValue)] ? [totalPhotosCount integerValue] : -1;
        
        id pageIndex = searchResult[@"page"];
        _pageIndex = [pageIndex respondsToSelector:@selector(integerValue)] ? [pageIndex integerValue] : -1;
    }
    return self;
}

@end
