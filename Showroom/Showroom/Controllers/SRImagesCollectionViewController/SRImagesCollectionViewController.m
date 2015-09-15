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
#import "CSStickyHeaderFlowLayout.h"

// Controllers
#import "SRImageViewController.h"
#import "SRDiaporamaViewController.h"

// Helpers
#import "SRImage+Helper.h"

#define MARGIN 10

@interface SRImagesCollectionViewController ()

@end

@implementation SRImagesCollectionViewController

#pragma mark - Constructor

+ (instancetype)newWithResultController:(NSFetchedResultsController *)fetchResultController {
    return [[SRImagesCollectionViewController alloc] initWithResultController:fetchResultController];
}

- (id)initWithResultController:(NSFetchedResultsController *)fetchResultController {
    self = [super init];
    if (self) {
        self.fetchedResultsController = fetchResultController;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializaView];
    
    [SRCollectionReusableHeader registerToCollectionView:self.collectionView];
    [SRCollectionReusableFooter registerToCollectionView:self.collectionView];
    [SRImageCollectionViewCell registerToCollectionView:self.collectionView];
    
    [self setTitleWithAppIcon];
    
    self.screenName = @"Image collection";
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateCollectionViewLayoutWithSize:size];
}

- (void)updateCollectionViewLayoutWithSize:(CGSize)size {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = [self sizeForItemWithViewSize:size];
    [layout invalidateLayout];
}

#pragma mark - Initialization

- (UICollectionViewFlowLayout *)createCollectionViewLayout {
    UICollectionViewFlowLayout *collectionViewLayout = [[CSStickyHeaderFlowLayout alloc] init];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    collectionViewLayout.itemSize = [self sizeForItemWithViewSize:[[UIScreen mainScreen] bounds].size];
    collectionViewLayout.minimumInteritemSpacing = MARGIN;
    collectionViewLayout.minimumLineSpacing = MARGIN;
    collectionViewLayout.headerReferenceSize = CGSizeMake(50, 50);
    collectionViewLayout.footerReferenceSize = CGSizeMake(50, 50);
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return collectionViewLayout;
}

- (CGSize)sizeForItemWithViewSize:(CGSize)size {
    CGFloat numberOfItem = (size.width < size.height) ? 4 : 6;
    CGFloat numberOfSpacing = numberOfItem + 1;
    CGFloat totalItemsWidth = size.width - numberOfSpacing*MARGIN;
    CGFloat itemWidth = totalItemsWidth/numberOfItem;
    return CGSizeMake(itemWidth, itemWidth);
}

- (void)initializaView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.collectionViewLayout = [self createCollectionViewLayout];
}

#pragma mark - Getters & Setters

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRImageCollectionViewCell reusableIdentifier];
    SRImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    SRImage *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.imageView.image = [image thumbnail];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRCollectionReusableHeader reusableIdentifier];
    SRCollectionReusableHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
    header.title = [self titleForSection:indexPath.section];
    return header;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRCollectionReusableFooter reusableIdentifier];
    SRCollectionReusableFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
    return footer;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SRImage *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SRDiaporamaViewController *destination = [SRDiaporamaViewController newWithResultController:self.fetchedResultsController activeImage:image];
    [self.navigationController pushViewController:destination animated:YES];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
