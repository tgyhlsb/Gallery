//
//  SRImagesCollectionViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImagesCollectionViewController.h"


#define MARGIN 10

@interface SRImagesCollectionViewController ()

@property (strong, nonatomic) SRDirectory *directory;

@end

@implementation SRImagesCollectionViewController

#pragma mark - Constructor

+ (instancetype)newWithDirectory:(SRDirectory *)directory {
    return [[SRImagesCollectionViewController alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(SRDirectory *)directory {

    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    collectionViewLayout.itemSize = [self sizeForItem];
    collectionViewLayout.minimumInteritemSpacing = MARGIN;
    collectionViewLayout.minimumLineSpacing = MARGIN;
    collectionViewLayout.headerReferenceSize = CGSizeMake(50, 50);
    collectionViewLayout.footerReferenceSize = CGSizeMake(50, 50);
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    if (self) {
        self.directory = directory;
    }
    return self;
}

#pragma mark - Initialization

- (CGSize)sizeForItem {
    CGFloat numberOfItem = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? 4 : 6;
    CGFloat numberOfSpacing = numberOfItem + 1;
    CGFloat collectionViewWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat totalItemsWidth = collectionViewWidth - numberOfSpacing*MARGIN;
    CGFloat itemWidth = totalItemsWidth/numberOfItem;
    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark - Getters & Setters

- (void)setDirectory:(SRDirectory *)directory {
    _directory = directory;
    [self updateFetchedResultController];
}

#pragma mark - Fetch request

- (void)updateFetchedResultController {
    self.fetchedResultsController = [[SRModel defaultModel] fetchedResultControllerForImagesInDirectory:self.directory];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
