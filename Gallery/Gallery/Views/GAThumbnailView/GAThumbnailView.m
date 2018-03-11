//
//  GAThumbnailView.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 05/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAThumbnailView.h"

// Managers
#import "GACacheManager.h"
#import "GASettingsManager.h"

@interface GAThumbnailView()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation GAThumbnailView

#pragma mark - View life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentMode = [GASettingsManager thumbnailMode];
    self.clipsToBounds = YES;
}

#pragma mark - Getters & Setters

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.color = [UIColor blackColor];
        [self addSubview:_activityIndicator];
    }
    return _activityIndicator;
}

- (void)setFile:(GAFile *)file {
    _file = file;
    [self updateImageView];
}

#pragma mark - Image processing

- (void)updateImageView {
    self.image = nil;
    [self startLoading];
    CGSize imageSize = [self imageSizeFromScale];
    [GACacheManager thumbnailForFile:self.file andSize:imageSize inBackgroundWithBlock:^(UIImage *thumbnail) {
        self.image = thumbnail;
        [self stopLoading];
    }];
}

#define MIN_SCALE 0.5

- (CGSize)imageSizeFromScale {
    CGSize size = (self.preferredSize.width*self.preferredSize.height > 0) ? self.preferredSize : self.frame.size;
    CGFloat scale = MAX(self.scale, MIN_SCALE);
    return CGSizeMake(size.width*scale, size.height*scale);
}

#pragma mark - Activity Indicator

- (void)startLoading {
    [self.activityIndicator startAnimating];
}

- (void)stopLoading {
    [self.activityIndicator stopAnimating];
}

@end
