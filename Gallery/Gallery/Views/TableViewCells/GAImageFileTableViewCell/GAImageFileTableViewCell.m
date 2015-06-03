//
//  GAImageFileTableViewCell.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 05/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageFileTableViewCell.h"

// Views
#import "GAThumbnailView.h"

@interface GAImageFileTableViewCell()

@property (weak, nonatomic) IBOutlet GAThumbnailView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation GAImageFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureView];
}

#pragma mark - Getters & Setters

- (void)setImageFile:(GAFile *)imageFile {
    _imageFile = imageFile;
    [self updateView];
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

#pragma mark - View processing

- (void)configureView {
    
}

- (void)updateView {
    self.thumbnailView.file = self.imageFile;
    self.titleLabel.text = [self.imageFile nameWithExtension:YES];
    
    if ([self.imageFile isDirectory]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
