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
}

#pragma mark - Getters & Setters

- (void)setImage:(SRImage *)image {
    if (![image isEqual:_image]) {
        _image = image;
        [self updateImageView];
    }
}

- (void)setImageView:(UIImageView *)imageView {
    _imageView = imageView;
    [self initializeImageView];
}

#pragma mark - View methods

- (void)initializeImageView {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self updateImageView];
}

- (void)updateImageView {
    self.imageView.image = [UIImage imageNamed:self.image.path];
}

@end
