//
//  SRImageCollectionViewCell.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImageCollectionViewCell.h"

@interface SRImageCollectionViewCell()

@end

@implementation SRImageCollectionViewCell

#pragma mark - Initialization

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
    self.titleLabel.text = nil;
    [self.layer shouldRasterize];
}

@end
