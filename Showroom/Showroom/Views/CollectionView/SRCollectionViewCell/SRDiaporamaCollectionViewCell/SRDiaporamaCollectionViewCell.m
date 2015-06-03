//
//  SRDiaporamaCollectionViewCell.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 03/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDiaporamaCollectionViewCell.h"

@interface SRDiaporamaCollectionViewCell() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation SRDiaporamaCollectionViewCell

#pragma mark - Initialization

- (void)awakeFromNib {
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
    [self.layer shouldRasterize];
}

#pragma mark - Getters & Setters

- (UIImageView *)imageView {
    if (!_imageView && _scrollView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_imageView];
        _scrollView.delegate = self;
    }
    return _imageView;
}

@synthesize image = _image;

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self updateFramesWithImage:image];
}

#pragma mark - Scale

- (void)updateFramesWithImage:(UIImage *)image {
    if (image) {
        [self.scrollView setZoomScale:1 animated:NO];
        self.imageView.frame = CGRectZero;
        self.scrollView.contentSize = CGSizeZero;
        
        CGFloat widthRatio = self.scrollView.frame.size.width/image.size.width;
        CGFloat heightRatio = self.scrollView.frame.size.height/image.size.height;
        CGFloat ratio = MIN(widthRatio, heightRatio);
        
        CGRect frame = CGRectZero;
        if (widthRatio < heightRatio) {
            frame = CGRectMake(0, 0, image.size.width, self.scrollView.frame.size.height/ratio);
        } else {
            frame = CGRectMake(0, 0, self.scrollView.frame.size.width/ratio, image.size.height);
        }
        
        self.imageView.frame = frame;
        self.scrollView.contentSize = self.imageView.image.size;
        [self saveScaleToFit:ratio];
    }
}

- (void)saveScaleToFit:(CGFloat)scale {
    [self.scrollView setMinimumZoomScale:scale];
    [self.scrollView setZoomScale:scale animated:NO];
}

- (void)setScaleToFit {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

@end
