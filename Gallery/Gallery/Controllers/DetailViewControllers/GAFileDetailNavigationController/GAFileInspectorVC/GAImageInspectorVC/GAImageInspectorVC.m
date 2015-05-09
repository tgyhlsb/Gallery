//
//  GAImageInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageInspectorVC.h"

@interface GAImageInspectorVC () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL isScrollViewInitialized;

@end

@implementation GAImageInspectorVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.isScrollViewInitialized) {
        [self updateFramesWithImage:self.imageView.image];
    } else {
        self.isScrollViewInitialized = YES;
        [self initializedFramesWith:self.imageView.image];
    }
}

#pragma mark - Getters & Setters

- (void)setFile:(GAFile *)file {
    if (file.isImage) {
        [super setFile:file];
    } else {
        [GALogger addError:@"Invalid imageFile \"%@\"", file.path];
    }
}

- (UIImageView *)imageView {
    if (!_imageView && _scrollView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor blueColor];
        [_scrollView addSubview:_imageView];
        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
    }
    return _imageView;
}

#pragma mark - View

- (void)updateViewWithFile:(GAFile *)file {
    self.imageView.image = [UIImage imageWithContentsOfFile:self.file.path];
}

- (void)initializedFramesWith:(UIImage *)image {
    if (image) {
        CGFloat widthRatio = self.scrollView.frame.size.width/image.size.width;
        CGFloat heightRatio = self.scrollView.frame.size.height/image.size.height;
        CGFloat ratio = 0;
        if (widthRatio < heightRatio) {
            ratio = widthRatio;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, self.scrollView.frame.size.height/ratio);
        } else {
            ratio = heightRatio;
            self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width/ratio, image.size.height);
        }
        
        NSLog(@"%f", ratio);
        self.scrollView.contentSize = self.imageView.frame.size;
        [self.scrollView setZoomScale:ratio animated:YES];
    }
}

- (void)updateFramesWithImage:(UIImage *)image {
    if (image) {
        CGFloat widthRatio = self.scrollView.frame.size.width/image.size.width;
        CGFloat heightRatio = self.scrollView.frame.size.height/image.size.height;
        CGFloat ratio = MIN(widthRatio, heightRatio);
        self.scrollView.contentSize = self.imageView.frame.size;
        [self.scrollView setZoomScale:ratio animated:YES];
    }
}

- (CGFloat)minimumZoomForImage:(UIImage *)image inFrame:(CGRect)frame {
    CGFloat widthRatio = frame.size.width/image.size.width;
    CGFloat heightRatio = frame.size.height/image.size.height;
    return MAX(widthRatio, heightRatio);
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

@end
