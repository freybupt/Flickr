//
//  SearchHistoryController.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import "SearchHistoryController.h"
#import "PhotoSearchResult.h"

@implementation SearchHistoryController

- (void)saveSearchHistoryWithSearchTerm:(NSString *)text results:(PhotoSearchResult *)searchResult
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SearchHistory.plist"];
    
    NSDictionary *content = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (!content) {
        content = [NSDictionary new];
    }
    NSMutableDictionary *updatedContent = [content mutableCopy];
    [updatedContent setObject:@(searchResult.totalPhotosCount) forKey:text];
    [updatedContent writeToFile:plistPath atomically:YES];
}

- (NSDictionary *)retrieveAllSearchHistory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SearchHistory.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"SearchHistory" ofType:@"plist"];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return dict;
}

@end
