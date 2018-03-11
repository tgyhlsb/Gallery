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

@property (weak, nonatomic) IBOutlet GAThumbnailView *thumbnailView;

@end

@implementation GAImageCollectionViewCell

#pragma mark - Initialization

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
}

#pragma mark - Getters & Setters

- (void)setImageFile:(GAImageFile *)imageFile {
    _imageFile = imageFile;
    self.thumbnailView.file = imageFile;
}

- (void)setThumbnailView:(GAThumbnailView *)thumbnailView {
    thumbnailView.preferredSize = self.thumbnailPreferredSize;
    thumbnailView.scale = self.thumbnailScale;
    _thumbnailView = thumbnailView;
}

- (void)setThumbnailPreferredSize:(CGSize)thumbnailPreferredSize {
    _thumbnailPreferredSize = thumbnailPreferredSize;
    self.thumbnailView.preferredSize = thumbnailPreferredSize;
}

- (void)setThumbnailScale:(CGFloat)thumbnailScale {
    _thumbnailScale = thumbnailScale;
    self.thumbnailView.scale = thumbnailScale;
}

@end
