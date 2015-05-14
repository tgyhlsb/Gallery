//
//  GACollectionReusableView.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACollectionReusableView.h"

@implementation GACollectionReusableView

+ (void)registerToCollectionView:(UICollectionView *)collectionView {
    UINib *nib = [UINib nibWithNibName:[self reusableIdentifier] bundle:nil];
    [collectionView registerNib:nib forSupplementaryViewOfKind:[self preferredKind] withReuseIdentifier:[self reusableIdentifier]];
}

+ (NSString *)reusableIdentifier {
    return [[self class] description];
}

+ (NSString *)preferredKind {
    return nil;
}

- (id)init {
    return [super init];
}

- (id)initWithFrame:(CGRect)frame {
    return [super initWithFrame:frame];
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor greenColor];
}

@end
