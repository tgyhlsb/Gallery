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

+ (instancetype)imageFileFromPath:(NSString *)path
                           parent:(GADirectory *)parent {
    
    return [[GAImageFile alloc] initFromPath:path parent:parent];
}

- (id)initFromPath:(NSString *)path
            parent:(GADirectory *)parent {
    
    self = [super initFromPath:path parent:parent];
    if (self) {
        [GAImageFile newObject:self];
    }
    return self;
}

#pragma mark - Factory

static NSMutableArray *existingObjects;

+ (NSMutableArray *)existingObjects {
    if (!existingObjects) {
        existingObjects = [[NSMutableArray alloc] init];
    }
    return existingObjects;
}

+ (void)newObject:(GAImageFile *)imageFile {
    [[self existingObjects] addObject:imageFile];
}

+ (void)deleteObject:(GAImageFile *)imageFile {
    [[self existingObjects] removeObject:imageFile];
}

- (void)dealloc {
    [GAImageFile deleteObject:self];
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
    return [@[@"jpg", @"png", @"jpeg"] containsObject:extension.lowercaseString];
}

@end
