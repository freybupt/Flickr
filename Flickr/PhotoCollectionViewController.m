//
//  PhotoCollectionViewController.m
//  Flickr
//
//  Created by Liang Shi on 2/28/16.
//  Copyright © 2016 Liang Shi. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "FlickrSearchManager.h"
#import "PhotoSearchResult.h"
#import "PhotoResult.h"

static NSString *photoCellIdentifier = @"photoCellIdentifier";
static CGFloat kDefaultPhotoCellHeight = 100.f;
static NSInteger kDefaultNumberOfColumn = 3;

@interface PhotoCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *photosURLArray; // store current available URLs

@end

@implementation PhotoCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicatorView.center = self.view.center;
    self.activityIndicatorView.userInteractionEnabled = NO;
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    
    self.photosURLArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // flush image cache in case of memory warning
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // reload visible cells - always show 3 columns
    [self.collectionView reloadItemsAtIndexPaths:
     [self.collectionView indexPathsForVisibleItems]];
}

#pragma mark <PhotoSearchControllerDelegate>

- (void)updateWithSearchResult:(PhotoSearchResult *)searchResult
{ 
    if (searchResult) {
        NSMutableArray *photoURLArray = [NSMutableArray new];
        
        // parse search result to get photo URLs
        [searchResult.photosArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull photoDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
            PhotoResult *photoResult = [[PhotoResult alloc] initWithDictionary:photoDictionary];
            NSURL *photoURL = [PhotoResult photoURLWithPhotoResult:photoResult];
            if (photoURL) {
                [photoURLArray addObject:photoURL];
            }
        }];
        
        // get index paths for new cells
        NSInteger currentPhotoCount = self.photosURLArray.count;
        NSInteger updatedPhotoCount = currentPhotoCount + searchResult.photosArray.count;
        NSMutableArray *indexPathArray = [NSMutableArray new];
        for (NSUInteger index = currentPhotoCount; index < updatedPhotoCount; index++) {
            [indexPathArray addObject:[NSIndexPath indexPathForItem:index inSection:0]];
        }
        
        // update URL cache and refresh collection view with new cells only
        [self.photosURLArray addObjectsFromArray:photoURLArray];
        [self.collectionView insertItemsAtIndexPaths:indexPathArray];
    }
}

- (void)flushAllResults
{
    [self.photosURLArray removeAllObjects];
    [self.collectionView reloadData];
}

- (void)showLoadingStatus:(BOOL)showLoading withMessage:(NSString *)loadingMessage
{
    if (showLoading) {
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    }
    else{
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photosURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(PhotoCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    [cell.imageView setShowActivityIndicatorView:YES];
    [cell.imageView setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // set and cache image asynchronously
    NSURL *photoURL = [self.photosURLArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:photoURL
                      placeholderImage:nil
                               options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // calculate colume width - always show 3 column
    CGFloat phtoCellWidth = (collectionView.bounds.size.width - collectionViewLayout.minimumInteritemSpacing * kDefaultNumberOfColumn)/kDefaultNumberOfColumn;
    return CGSizeMake(phtoCellWidth, kDefaultPhotoCellHeight);
}

@end
