//
//  FlickrSearchManager.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "FlickrSearchManager.h"
#import "PhotosJsonParser.h"
#import "PhotoSearchResult.h"
#import "PhotoResult.h"

@interface FlickrSearchManager ()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation FlickrSearchManager

static NSString *flickerServiceLink = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&text=";

+ (instancetype)sharedManager
{
    static FlickrSearchManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlickrSearchManager alloc] init];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        manager.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    
    return manager;
}

- (void)resumeSearch
{
    [self.dataTask resume];
}

- (void)suspendSearch
{
    [self.dataTask suspend];
}

- (void)requestPhotoURLsWithSearchText:(NSString *)text completionHandler:(FSRequestHandler)requestHandler
{
    if (!text || text.length == 0) {
        return;
    }

    [self requestPhotoDataWithText:text page:1 completionHandler:requestHandler];
}


- (void)requestPhotoDataWithText:(NSString *)text page:(NSInteger)page completionHandler:(FSRequestHandler)requestHandler
{
    NSString *searchURLString = [NSString stringWithFormat:@"%@%@&page=%@",
                                 flickerServiceLink,
                                 text,
                                 @(page)];
    
    NSURL *URL = [NSURL URLWithString:searchURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // request for photo search results asynchronously
    self.dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            PhotosJsonParser *jsonParser = [[PhotosJsonParser alloc] init];
            PhotoSearchResult *searchResult = [jsonParser parseJSON:responseObject error:error];
            
            // sometimes response contains nil photo, blocked due to too frequent request?
            if (searchResult && searchResult.photosArray) {
                if (requestHandler) {
                    requestHandler(searchResult, error);
                }
                
                // load the following pages recursively until the last page
                if (searchResult.pageIndex - 1 < searchResult.totalPagesCount) {
                    [self requestPhotoDataWithText:text page:searchResult.pageIndex+1 completionHandler:requestHandler];
                }
            }
        
    }
    }];
    [self.dataTask resume];
    
}

@end
