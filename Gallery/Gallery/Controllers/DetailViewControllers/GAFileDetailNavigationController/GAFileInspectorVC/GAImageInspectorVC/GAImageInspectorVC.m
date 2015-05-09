//
//  GAImageInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageInspectorVC.h"

@interface GAImageInspectorVC () <UIScrollViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *zoomResetButton;
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
    [self updateFramesWithImage:self.imageView.image];
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
        [_scrollView addSubview:_imageView];
        _scrollView.delegate = self;
    }
    return _imageView;
}

- (UIBarButtonItem *)zoomResetButton {
    if (!_zoomResetButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_ZOOM_RESET", nil);
        _zoomResetButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(zoomResetButtonHandler)];
    }
    return _zoomResetButton;
}

#pragma mark - Handlers

- (void)zoomResetButtonHandler {
    [self setScaleToFit];
}

#pragma mark - View

- (void)updateViewWithFile:(GAFile *)file {
    self.imageView.image = [UIImage imageWithContentsOfFile:self.file.path];
}

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

#pragma mark - GAFileInspectorBarButtonsDataSource

- (NSArray *)topRightBarItemsForDisplayedFile {
    return @[self.zoomResetButton];
}

@end
