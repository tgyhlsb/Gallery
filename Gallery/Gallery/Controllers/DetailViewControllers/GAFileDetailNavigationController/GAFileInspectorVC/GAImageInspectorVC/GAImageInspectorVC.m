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
    if (YES) {
        [self updateFramesWithImage:self.imageView.image];
    } else {
        self.isScrollViewInitialized = YES;
        [self initializedFramesWith:self.imageView.image];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
//        _imageView = nil;
//        self.imageView.image = [UIImage imageWithContentsOfFile:self.file.path];
//        [self initializedFramesWith:self.imageView.image];
        
    }];
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
        NSLog(@"-------------");
        NSLog(@"%.2f - %.2f", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        NSLog(@"%.2f - %.2f", image.size.width, image.size.height);
        NSLog(@"> %.2f - %.2f", self.imageView.frame.size.width, self.imageView.frame.size.height);
        
        self.imageView.frame = CGRectZero;
        self.scrollView.contentSize = CGSizeZero;
        CGFloat widthRatio = self.scrollView.frame.size.width/image.size.width;
        CGFloat heightRatio = self.scrollView.frame.size.height/image.size.height;
        CGFloat ratio = MIN(widthRatio, heightRatio);
        
        if (widthRatio < heightRatio) {
            self.imageView.frame = CGRectMake(0, 0, image.size.width, self.scrollView.frame.size.height/ratio);
        } else {
            self.imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width/ratio, image.size.height);
        }
        
        self.scrollView.contentSize = self.imageView.image.size;
        [self.scrollView setZoomScale:ratio animated:YES];
        NSLog(@"> %.2f - %.2f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    }
}

- (void)updateFramesWithImage:(UIImage *)image {
    if (image) {
        [self.scrollView setZoomScale:1 animated:NO];
        NSLog(@"-------------");
        NSLog(@"%.2f - %.2f", self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        NSLog(@"%.2f - %.2f", image.size.width, image.size.height);
        NSLog(@"> %.2f - %.2f", self.imageView.frame.size.width, self.imageView.frame.size.height);
        
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
        
        NSLog(@"> %.2f - %.2f", frame.size.width, frame.size.height);
        self.imageView.frame = frame;
        NSLog(@"> %.2f - %.2f", self.imageView.frame.size.width, self.imageView.frame.size.height);
        self.scrollView.contentSize = self.imageView.image.size;
        [self.scrollView setZoomScale:ratio animated:NO];
        NSLog(@"> %.2f - %.2f", self.imageView.frame.size.width, self.imageView.frame.size.height);
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
