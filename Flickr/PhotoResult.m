//
//  PhotoResult.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import "PhotoResult.h"

@interface PhotoResult ()

@property (nonatomic, strong, readwrite) NSString *photoId;
@property (nonatomic, strong, readwrite) NSString *owner;
@property (nonatomic, strong, readwrite) NSString *secret;
@property (nonatomic, strong, readwrite) NSString *server;
@property (nonatomic, assign, readwrite) NSInteger farm;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, assign, readwrite) NSInteger isPublic;
@property (nonatomic, assign, readwrite) NSInteger isFriend;
@property (nonatomic, assign, readwrite) NSInteger isFamily;

@end

@implementation PhotoResult

- (instancetype)initWithDictionary:(NSDictionary *)photoDictionary
{
    if (self = [super init]) {
        id photoId = photoDictionary[@"id"];
        _photoId = [photoId isKindOfClass:[NSString class]] ? photoId : nil;
        
        id owner = photoDictionary[@"owner"];
        _owner = [owner isKindOfClass:[NSString class]] ? owner : nil;
        
        id secret = photoDictionary[@"secret"];
        _secret = [secret isKindOfClass:[NSString class]] ? secret : nil;
        
        id server = photoDictionary[@"server"];
        _server = [server isKindOfClass:[NSString class]] ? server : nil;
        
        id title = photoDictionary[@"title"];
        _title = [title isKindOfClass:[NSString class]] ? title : nil;
        
        id farm = photoDictionary[@"farm"];
        _farm = [farm respondsToSelector:@selector(integerValue)] ? [farm integerValue] : -1;
        
        id isPublic = photoDictionary[@"isPublic"];
        _isPublic = [isPublic respondsToSelector:@selector(integerValue)] ? [isPublic integerValue] : -1;
        
        id isFriend = photoDictionary[@"isFriend"];
        _isFriend = [isFriend respondsToSelector:@selector(integerValue)] ? [isFriend integerValue] : -1;
        
        id isFamily = photoDictionary[@"isFamily"];
        _isFamily = [isFamily respondsToSelector:@selector(integerValue)] ? [isFamily integerValue] : -1;
    }
    return self;
}

+ (NSURL *)photoURLWithPhotoResult:(PhotoResult *)photoResult
{
    if (photoResult &&
        @(photoResult.farm) &&
        photoResult.server &&
        photoResult.photoId &&
        photoResult.secret) {
        //   e.g.    http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
        //             http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg
        NSString *photoURLString = [NSString stringWithFormat:
                                    @"https://farm%@.static.flickr.com/%@/%@_%@.jpg",
                                    @(photoResult.farm),
                                    photoResult.server,
                                    photoResult.photoId,
                                    photoResult.secret];
        
        NSURL *photoURL = [NSURL URLWithString:photoURLString];
        return photoURL;
    }
    
    return nil;
}

@end
