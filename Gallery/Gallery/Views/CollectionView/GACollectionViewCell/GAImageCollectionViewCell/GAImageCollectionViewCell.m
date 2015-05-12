//
//  GAImageCollectionViewCell.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageCollectionViewCell.h"

// Views
#import "GAThumbnailView.h"

@interface GAImageCollectionViewCell()

@property (weak, nonatomic) IBOutlet GAThumbnailView *imageView;

@end

@implementation GAImageCollectionViewCell

#pragma mark - Initialization

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Getters & Setters

- (void)setImageFile:(GAImageFile *)imageFile {
    _imageFile = imageFile;
    self.imageView.file = imageFile;
}

@end
