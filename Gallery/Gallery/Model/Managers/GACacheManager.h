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

// Blocks
typedef void (^GAThumbnailLoadingBlock)(UIImage *thumbnail);

@interface GACacheManager : NSObject

+ (instancetype)sharedManager;
+ (void)clearThumbnails;

+ (UIImage *)thumbnailForFile:(GAFile *)file andSize:(CGSize)size;
+ (void)thumbnailForFile:(GAFile *)file andSize:(CGSize)size inBackgroundWithBlock:(GAThumbnailLoadingBlock)block;
+ (void)thumbnailsForFiles:(NSArray *)files andSize:(CGSize)size inBackgroundWithBlock:(GAThumbnailLoadingBlock)block;

@end
