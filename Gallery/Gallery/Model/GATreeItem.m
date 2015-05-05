//
//  ILTreeItem.m
//  ios-lab
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GATreeItem.h"

@interface GATreeItem()

@property (strong, nonatomic, readwrite) NSString *path;
@property (strong, nonatomic, readwrite) UIImage *thumbnail;

@end

@implementation GATreeItem

#pragma mark - Constructors


- (id)initFromPath:(NSString *)path {
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}

#pragma mark - Getters

- (NSString *)nameWithExtension:(BOOL)extension {
    return extension ? [self.path lastPathComponent] : [[self.path lastPathComponent] stringByDeletingPathExtension];
}

- (UIImage *)imageForThumbnail {
    return nil;
}

- (BOOL)isDirectory {
    return NO;
}

- (BOOL)isImage {
    return NO;
}


@end
