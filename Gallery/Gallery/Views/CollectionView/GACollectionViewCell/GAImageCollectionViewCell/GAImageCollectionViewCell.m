//
//  GAImageCollectionViewCell.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageCollectionViewCell.h"

@interface GAImageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation GAImageCollectionViewCell

#pragma mark - Initialization

- (void)awakeFromNib {
    self.backgroundColor = [UIColor redColor];
}

@end
