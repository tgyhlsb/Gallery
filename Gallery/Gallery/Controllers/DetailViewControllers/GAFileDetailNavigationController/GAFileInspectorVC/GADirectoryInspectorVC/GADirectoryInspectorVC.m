//
//  GADirectoryInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryInspectorVC.h"

@interface GADirectoryInspectorVC ()

@property (weak, nonatomic) IBOutlet UILabel *directoryNameLabel;

@end

@implementation GADirectoryInspectorVC

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
    if (file.isDirectory) {
        [super setFile:file];
    } else {
        [GALogger addError:@"Invalid directory \"%@\"", file.path];
    }
}

#pragma mark - View

- (void)updateViewWithFile:(GAFile *)file {
    self.directoryNameLabel.text = [file nameWithExtension:NO];
}

@end
