//
//  GACacheManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import <Foundation/Foundation.h>

// Models
#import "GATreeItem.h"

@interface GACacheManager : NSObject

+ (void)shouldCacheThumbnails:(BOOL)shouldCacheThumbnails;
+ (void)clearThumbnails;

+ (UIImage *)thumbnailForTreeItem:(GATreeItem *)treeItem;

@end
