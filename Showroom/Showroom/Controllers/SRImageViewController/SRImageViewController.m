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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

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
        self.image = image;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.isVisible = YES;
    [super viewDidAppear:animated];
    [self loadImage];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isVisible = NO;
    [super viewDidDisappear:animated];
}

#pragma mark - Getters & Setters

- (void)setImage:(SRImage *)image {
    if (![image isEqual:_image]) {
        _image = image;
        [self updateView];
        [self loadImage];
    }
}

- (void)setImageView:(UIImageView *)imageView {
    _imageView = imageView;
}

#pragma mark - View methods

- (void)initializeView {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
}

- (void)updateView {
    self.title = self.image.name;
}

- (void)loadImage {
    if (self.isVisible) {
        self.imageView.image = [UIImage imageNamed:[self.image absolutePath]];
        [self.activityIndicator stopAnimating];
    }
}

@end
