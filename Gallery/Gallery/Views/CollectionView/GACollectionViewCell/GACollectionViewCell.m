//
//  GACollectionViewCell.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACollectionViewCell.h"

#import "GALogger.h"

@implementation GACollectionViewCell

+ (void)registerToCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:[self reusableIdentifier] bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[self reusableIdentifier]];
}

+ (NSString *)reusableIdentifier {
    return [[self class] description];
}

- (void)awakeFromNib {
    
}

@end
