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

// Views
#import "GAImageCollectionViewCell.h"
#import "GACollectionReusableHeader.h"
#import "GACollectionReusableFooter.h"

@interface GAImageCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation GAImageCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (void)initializeCollectionView {
    
    [GAImageCollectionViewCell registerToCollectionView:self.collectionView];
    [GACollectionReusableHeader registerToCollectionView:self.collectionView];
    [GACollectionReusableFooter registerToCollectionView:self.collectionView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(50, 20, 50, 20);
    collectionViewLayout.itemSize = CGSizeMake(50, 50);
    collectionViewLayout.headerReferenceSize = CGSizeMake(50, 50);
    collectionViewLayout.footerReferenceSize = CGSizeMake(50, 50);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [GAImageCollectionViewCell reusableIdentifier];
    GAImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
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
