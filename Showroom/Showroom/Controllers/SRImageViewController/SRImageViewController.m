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
#import "SRFile+Helper.h"

@interface SRImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (strong, nonatomic) NSTimer *hideTitleTimer;

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
    
    [self configureView];
    [self initializeGestures];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scroolViewNeedsLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideTitleButtonAfter:5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Appearance

- (void)configureView {
    [self.titleButton setTitle:[self.image nameWithExtension:YES] forState:UIControlStateNormal];
    [self.titleButton sizeToFit];
    
    self.titleButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleButton.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    self.titleButton.layer.cornerRadius = self.titleButton.frame.size.height/2;
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

#pragma mark - Gesture recognizers

- (void)initializeGestures {
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureHandler)];
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureHandler)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapGesture];
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
}

#pragma mark - Title animation


- (void)hideTitleButtonAfter:(NSTimeInterval)delay {
    [self.hideTitleTimer invalidate];
    self.hideTitleTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(hideTitleTimerHandler) userInfo:nil repeats:NO];
}

- (void)hideTitleButtonAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.titleButton.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.titleButton.alpha = 0;
    }
}

- (void)showTitleButtonAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.titleButton.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.titleButton.alpha = 1;
    }
}

- (void)hideTitleTimerHandler {
    [self hideTitleButtonAnimated:YES];
    self.hideTitleTimer = nil;
}

#pragma mark - Handlers

- (void)singleTapGestureHandler {
    if (self.hideTitleTimer) {
        [self.hideTitleTimer fire];
    } else {
        [self showTitleButtonAnimated:YES];
        [self hideTitleButtonAfter:5];
    }
    
    if ([self.delegate respondsToSelector:@selector(imageViewControllerDidSingleTap)]) {
        [self.delegate imageViewControllerDidSingleTap];
    }
}

- (void)doubleTapGestureHandler {
    
    if ([self.delegate respondsToSelector:@selector(imageViewControllerDidDoubleTap)]) {
        [self.delegate imageViewControllerDidDoubleTap];
    }
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
