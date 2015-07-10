//
//  SRTutorialSlideViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 21/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTutorialSlideViewController.h"

@interface SRTutorialSlideViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SRTutorialSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testLabel.text = self.message;
    self.imageView.image = self.image;
}

#pragma mark - Getters & Setters

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
