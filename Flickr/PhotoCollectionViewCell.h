//
//  PhotoCollectionViewCell.h
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIImageView *imageView;

@end
