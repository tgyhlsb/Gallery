//
//  GACacheManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import <Foundation/Foundation.h>

// Models
#import "GAFile.h"

@interface GACacheManager : NSObject

@property (nonatomic) NSInteger thumbnailCacheLimit;

+ (instancetype)sharedManager;

+ (void)shouldCacheThumbnails:(BOOL)shouldCacheThumbnails;
+ (void)clearThumbnails;

+ (UIImage *)thumbnailForFile:(GAFile *)file;

@end