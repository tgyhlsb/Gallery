//
//  GAFileInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFileInspectorVC.h"

// Controllers
#import "GADirectoryInspectorVC.h"
#import "GAImageInspectorVC.h"

@interface GAFileInspectorVC ()

@end

@implementation GAFileInspectorVC

+ (GAFileInspectorVC *)inspectorForFile:(GAFile *)file {
    if (file.isImage) {
        GAImageInspectorVC *controller = [GAImageInspectorVC new];
        controller.file = file;
        return controller;
    } else if (file.isDirectory) {
        GADirectoryInspectorVC *controller = [GADirectoryInspectorVC new];
        controller.file = file;
        return controller;
    } else {
        [GALogger addError:@"Invalid file \"%@\"", file.path];
        return [GAFileInspectorVC new];
    }
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViewWithFile:self.file];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

- (void)setFile:(GAFile *)file {
    _file = file;
    [self updateViewWithFile:file];
}

#pragma mark - View

- (void)updateViewWithFile:(GAFile *)file {
    
}


@end
