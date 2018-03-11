//
//  SRDiaporamaCollectionViewCell.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 03/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRCollectionViewCell.h"

@interface SRDiaporamaCollectionViewCell : SRCollectionViewCell

@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)updateFramesWithImage:(UIImage *)image;
- (void)setScaleToFit;

@end
