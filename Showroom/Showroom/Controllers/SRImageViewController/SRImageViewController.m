//
//  SRImageViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImageViewController.h"

// Model
#import "SRImage+Helper.h"

@interface SRImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) BOOL isVisible;

@end

@implementation SRImageViewController

#pragma mark - Constructor

+ (instancetype)newWithImage:(SRImage *)image {
    return [[SRImageViewController alloc] initWithImage:image];
}

- (id)initWithImage:(SRImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scroolViewNeedsLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Getters & Setters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [self.image image];
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - Scale

- (void)scroolViewNeedsLayout {
    [self updateFramesWithImage:[self.image image]];
}

- (void)updateFramesWithImage:(UIImage *)image {
    if (image) {
        [self.scrollView setZoomScale:1 animated:NO];
        self.imageView.frame = CGRectZero;
        self.scrollView.contentSize = CGSizeZero;
        
        CGRect containerFrame = self.parentViewController.view.bounds;
        
        CGFloat widthRatio = containerFrame.size.width/image.size.width;
        CGFloat heightRatio = containerFrame.size.height/image.size.height;
        CGFloat ratio = MIN(widthRatio, heightRatio);
        
        CGRect frame = CGRectZero;
        if (widthRatio < heightRatio) {
            frame = CGRectMake(0, 0, image.size.width, containerFrame.size.height/ratio);
        } else {
            frame = CGRectMake(0, 0, containerFrame.size.width/ratio, image.size.height);
        }
        
        
        if (frame.size.width < containerFrame.size.width || frame.size.height < containerFrame.size.height) {
            frame = containerFrame;
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
