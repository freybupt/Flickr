//
//  FlickrSearchManager.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoSearchResult;
@class PhotoResult;

typedef void (^FSRequestHandler)(PhotoSearchResult *searchResult, NSError *error);

@interface FlickrSearchManager : NSObject

+ (instancetype)sharedManager;

- (void)requestPhotoURLsWithSearchText:(NSString *)text
                     completionHandler:(FSRequestHandler)requestHandler;

- (void)resumeSearch;
- (void)suspendSearch;

@end
