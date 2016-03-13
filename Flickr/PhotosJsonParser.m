//
//  PhotosJsonParser.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import "PhotosJsonParser.h"
#import "PhotoSearchResult.h"

NSString * const FlickrPhotoParserErrorDomain = @"BCPriceBreakdownParserErrorDomain";

@implementation PhotosJsonParser

- (PhotoSearchResult *)parseJSON:(id)jsonObject error:(NSError *)error
{
    if (![jsonObject isKindOfClass:[NSDictionary class]]) {
        if (error) {
            error = [NSError errorWithDomain:FlickrPhotoParserErrorDomain code:0 userInfo:nil];
        }
        return nil;
    }
    
    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
    NSString *status = [jsonDictionary objectForKey:@"stat"];
    NSLog(@"Search status: %@", status);
    
    NSDictionary *photoSearchResultDict = [jsonDictionary objectForKey:@"photos"];
    PhotoSearchResult *searchResult = [[PhotoSearchResult alloc] initWithDictionary:photoSearchResultDict];
    return searchResult;
}


@end
