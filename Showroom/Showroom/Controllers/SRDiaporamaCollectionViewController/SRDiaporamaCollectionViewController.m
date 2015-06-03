//
//  SRDiaporamaCollectionViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDiaporamaCollectionViewController.h"

// Views
#import "SRCollectionReusableFooter.h"
#import "SRCollectionReusableHeader.h"
#import "SRDiaporamaCollectionViewCell.h"

// Controllers
#import "SRImageViewController.h"

// Helpers
#import "SRImage+Helper.h"

#define MARGIN 0

@interface SRDiaporamaCollectionViewController ()

@property (strong, nonatomic) SRDirectory *directory;
@property (strong, nonatomic) SRImage *selectedImage;

@end

@implementation SRDiaporamaCollectionViewController

#pragma mark - Constructor

+ (instancetype)newWithDirectory:(SRDirectory *)directory selectedImage:(SRImage *)selectedImage {
    return [[SRDiaporamaCollectionViewController alloc] initWithDirectory:directory selectedImage:selectedImage];
}

- (id)initWithDirectory:(SRDirectory *)directory selectedImage:(SRImage *)selectedImage {
    self = [super initWithCollectionViewLayout:[self createCollectionViewLayout]];
    if (self) {
        self.directory = directory;
        self.selectedImage = selectedImage;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializaView];
    
    [SRCollectionReusableHeader registerToCollectionView:self.collectionView];
    [SRCollectionReusableFooter registerToCollectionView:self.collectionView];
    [SRDiaporamaCollectionViewCell registerToCollectionView:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateCollectionViewLayoutWithSize:self.view.bounds.size];
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:self.selectedImage];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateCollectionViewLayoutWithSize:size];
}

- (void)updateCollectionViewLayoutWithSize:(CGSize)size {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = size;
    [layout invalidateLayout];
}

#pragma mark - Initialization

- (UICollectionViewFlowLayout *)createCollectionViewLayout {
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
    collectionViewLayout.minimumInteritemSpacing = MARGIN;
    collectionViewLayout.minimumLineSpacing = MARGIN;
    collectionViewLayout.headerReferenceSize = CGSizeMake(0, 0);
    collectionViewLayout.footerReferenceSize = CGSizeMake(0, 0);
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return collectionViewLayout;
}

- (void)initializaView {
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
}

#pragma mark - Getters & Setters

- (void)setDirectory:(SRDirectory *)directory {
    _directory = directory;
    [self updateFetchedResultController];
}

- (void)setSelectedImage:(SRImage *)selectedImage {
    _selectedImage = selectedImage;
    self.title = selectedImage.name;
}

#pragma mark - Fetch request

- (void)updateFetchedResultController {
    self.fetchedResultsController = [[SRModel defaultModel] fetchedResultControllerForImagesInDirectoryRecursively:self.directory];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRDiaporamaCollectionViewCell reusableIdentifier];
    SRDiaporamaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    SRImage *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.image = [image image];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRCollectionReusableHeader reusableIdentifier];
    SRCollectionReusableHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:identifier
                                                                                   forIndexPath:indexPath];
    
    header.titleLabel.text = [self titleForSection:indexPath.section];
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

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SRImage *image = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.selectedImage = image;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

@end
