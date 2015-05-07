//
//  GAImageFile.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAImageFile.h"

// Frameworks
#import <UIKit/UIKit.h>

@interface GAImageFile()

@end

@implementation GAImageFile

#pragma mark - Constructors

+ (instancetype)imageFileFromPath:(NSString *)path {
    return [[GAImageFile alloc] initFromPath:path];
}

- (id)initFromPath:(NSString *)path {
    self = [super initFromPath:path];
    if (self) {
    }
    return self;
}

#pragma mark - Getters & Setters

- (UIImage *)imageForThumbnail {
    return [UIImage imageWithContentsOfFile:self.path];
}

- (BOOL)isImage {
    return YES;
}

#pragma mark - Helpers

+ (BOOL)isImageFile:(NSString *)path {
    NSString *extension = [path pathExtension];
    return [@[@"jpg", @"png"] containsObject:extension.lowercaseString];
}

@end
