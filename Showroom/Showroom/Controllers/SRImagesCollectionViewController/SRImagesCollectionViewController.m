//
//  SRImagesCollectionViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImagesCollectionViewController.h"

// Views
#import "SRCollectionReusableFooter.h"
#import "SRCollectionReusableHeader.h"
#import "SRImageCollectionViewCell.h"

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
        
        [SRCollectionReusableHeader registerToCollectionView:self.collectionView];
        [SRCollectionReusableFooter registerToCollectionView:self.collectionView];
        [SRImageCollectionViewCell registerToCollectionView:self.collectionView];
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
    self.fetchedResultsController = [[SRModel defaultModel] fetchedResultControllerForImagesInDirectoryRecursively:self.directory];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRImageCollectionViewCell reusableIdentifier];
    SRImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    SRImage *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = image.name;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRCollectionReusableHeader reusableIdentifier];
    SRCollectionReusableHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    return header;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRCollectionReusableFooter reusableIdentifier];
    SRCollectionReusableFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
    return footer;
}

@end
