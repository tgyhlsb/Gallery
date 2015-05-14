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
@property (weak, nonatomic, readonly) GAFile *firstChild;
@property (weak, nonatomic, readonly) GAFile *lastChild;
@property (weak, nonatomic, readonly) GAImageFile *firstImage;
@property (weak, nonatomic, readonly) GAImageFile *lastImage;
@property (weak, nonatomic, readonly) GADirectory *firstDirectory;
@property (weak, nonatomic, readonly) GADirectory *lastDirectory;

+ (NSMutableArray *)existingObjects;

+ (instancetype)directoryFromPath:(NSString *)path
                           parent:(GAFile *)parent;

+ (BOOL)isDirectory:(NSString *)path;

@end
