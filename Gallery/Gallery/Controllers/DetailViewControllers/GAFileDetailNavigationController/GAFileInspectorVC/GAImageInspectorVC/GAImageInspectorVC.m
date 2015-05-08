//
//  GAImageInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageInspectorVC.h"

@interface GAImageInspectorVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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

#pragma mark - Getters & Setters

- (void)setFile:(GAFile *)file {
    if (file.isImage) {
        [super setFile:file];
    } else {
        [GALogger addError:@"Invalid imageFile \"%@\"", file.path];
    }
}

#pragma mark - View

- (void)updateViewWithFile:(GAFile *)file {
    self.imageView.image = [UIImage imageWithContentsOfFile:self.file.path];
}

@end
