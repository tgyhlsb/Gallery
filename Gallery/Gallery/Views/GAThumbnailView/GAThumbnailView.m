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
    [self startLoading];
    [GACacheManager thumbnailForFile:self.file inBackgroundWithBlock:^(UIImage *thumbnail) {
        self.image = thumbnail;
        [self stopLoading];
    }];
}

#pragma mark - Activity Indicator

- (void)startLoading {
    [self.activityIndicator startAnimating];
}

- (void)stopLoading {
    [self.activityIndicator stopAnimating];
}

@end
