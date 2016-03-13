//
//  PhotoResult.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 E.g.
 {
 "id": "23451156376",
 "owner": "28017113@N08",
 "secret": "8983a8ebc7",
 "server": "578",
 "farm": 1,
 "title": "Merry Christmas!",
 "ispublic": 1,
 "isfriend": 0,
 "isfamily": 0
 },
 */

@interface PhotoResult : NSObject

@property (nonatomic, strong, readonly) NSString *photoId;
@property (nonatomic, strong, readonly) NSString *owner;
@property (nonatomic, strong, readonly) NSString *secret;
@property (nonatomic, strong, readonly) NSString *server;
@property (nonatomic, assign, readonly) NSInteger farm;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger isPublic;
@property (nonatomic, assign, readonly) NSInteger isFriend;
@property (nonatomic, assign, readonly) NSInteger isFamily;

- (instancetype)initWithDictionary:(NSDictionary *)photoDictionary;

+ (NSURL *)photoURLWithPhotoResult:(PhotoResult *)photoResult;

@end

