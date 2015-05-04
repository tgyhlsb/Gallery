//
//  GARightVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GARightVC.h"

@interface GARightVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation GARightVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

- (void)setImageFile:(GAImageFile *)imageFile {
    _imageFile = imageFile;
    [self updateImageView];
}

#pragma mark - View methods

- (void)updateImageView {
    self.imageview.image = [UIImage imageWithContentsOfFile:self.imageFile.path];
}

@end
