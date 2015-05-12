//
//  GAImageCollectionViewController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageCollectionViewController.h"

// Managers
#import "GALogger.h"
#import "GASettingsManager.h"
#import "GAFileManager.h"

// Views
#import "GAImageCollectionViewCell.h"
#import "GACollectionReusableHeader.h"
#import "GACollectionReusableFooter.h"

@interface GAImageCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *directories;

@end

@implementation GAImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCollectionView];
    self.directories = [GADirectory existingObjects];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization


#define MARGIN 10

- (void)initializeCollectionView {
    
    [GAImageCollectionViewCell registerToCollectionView:self.collectionView];
    [GACollectionReusableHeader registerToCollectionView:self.collectionView];
    [GACollectionReusableFooter registerToCollectionView:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    collectionViewLayout.itemSize = [self sizeForItem];
    collectionViewLayout.minimumInteritemSpacing = MARGIN;
    collectionViewLayout.minimumLineSpacing = MARGIN;
    collectionViewLayout.headerReferenceSize = CGSizeMake(50, 50);
    collectionViewLayout.footerReferenceSize = CGSizeMake(50, 50);
}

- (CGSize)sizeForItem {
    CGFloat numberOfItem = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? [GASettingsManager pictureNumberPortrait] : [GASettingsManager pictureNumberLandscape];
    CGFloat numberOfSpacing = numberOfItem + 1;
    CGFloat collectionViewWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat totalItemsWidth = collectionViewWidth - numberOfSpacing*MARGIN;
    CGFloat itemWidth = totalItemsWidth/numberOfItem;
    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark - UICollectionViewDataSource

- (GAImageFile *)imageFileAtIndexPath:(NSIndexPath *)indexPath {
    return [[self directoryAtIndex:indexPath.section].images objectAtIndex:indexPath.row];
}

- (GADirectory *)directoryAtIndex:(NSInteger)index {
    return [self.directories objectAtIndex:index];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.directories count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self directoryAtIndex:section].images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [GAImageCollectionViewCell reusableIdentifier];
    GAImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.imageFile = [self imageFileAtIndexPath:indexPath];
    
    [cell.layer shouldRasterize];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        return [self collectionView:collectionView viewForHeaderAtIndexPath:indexPath];
    } else if (kind == UICollectionElementKindSectionFooter) {
        return [self collectionView:collectionView viewForFooterAtIndexPath:indexPath];
    } else {
        [GALogger addError:@"Unknown kind '%@'", kind];
        return nil;
    }
}


- (GACollectionReusableHeader *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [GACollectionReusableHeader reusableIdentifier];
    GACollectionReusableHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
    header.directory = [self directoryAtIndex:indexPath.section];
    return header;
}


- (GACollectionReusableFooter *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [GACollectionReusableFooter reusableIdentifier];
    GACollectionReusableFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
    return footer;
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(50, 50);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake(50, 50);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(50, 50);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(50, 20, 50, 20);
//}

@end
