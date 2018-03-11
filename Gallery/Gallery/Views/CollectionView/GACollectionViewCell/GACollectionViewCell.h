//
//  GACollectionViewCell.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GACollectionViewCell : UICollectionViewCell

+ (void)registerToCollectionView:(UICollectionView *)collectionView;
+ (NSString *)reusableIdentifier;

@end
