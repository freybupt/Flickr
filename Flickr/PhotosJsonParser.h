//
//  PhotosJsonParser.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FlickrPhotoParserErrorDomain;

@class PhotoSearchResult;

@interface PhotosJsonParser : NSObject

- (PhotoSearchResult *)parseJSON:(id)jsonObject error:(NSError *)error;

@end
