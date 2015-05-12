//
//  GAImageCollectionViewCell.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageCollectionViewCell.h"

@implementation GAImageCollectionViewCell

#pragma mark - Class

//+ (void)registerToCollectionView:(UICollectionView *)collectionView {
//    NSString *name = [[self class] description];
//    UINib *nib = [UINib nibWithNibName:name bundle:nil];
//    [collectionView registerNib:nib forCellWithReuseIdentifier:name];
//}

#pragma mark - Initialization

- (void)awakeFromNib {
    self.backgroundColor = [UIColor redColor];
}

@end
