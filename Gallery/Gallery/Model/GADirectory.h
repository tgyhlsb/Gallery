//
//  GADirectory.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import "GAFile.h"

// Frameworks
#import <Foundation/Foundation.h>

// Models
#import "GAImageFile.h"

@interface GADirectory : GAFile

@property (strong, nonatomic, readonly) NSArray *tree;
@property (strong, nonatomic, readonly) NSArray *images;
@property (strong, nonatomic, readonly) NSArray *directories;
@property (strong, nonatomic, readonly) NSArray *recursiveImages;
@property (strong, nonatomic, readonly) NSArray *recursiveDirectories;

+ (instancetype)directoryFromPath:(NSString *)path
                           parent:(GAFile *)parent;

+ (BOOL)isDirectory:(NSString *)path;

@end
