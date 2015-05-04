//
//  GACacheManager.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACacheManager.h"

static GACacheManager *sharedManager;

@interface GACacheManager()

@property (nonatomic) BOOL shouldCacheThumbnails;
@property (strong, nonatomic) NSMutableDictionary *thumbnails;

@end

@implementation GACacheManager

#pragma mark - Singleton

+ (GACacheManager *)sharedManager {
    if (!sharedManager) sharedManager = [GACacheManager new];
    return sharedManager;
}

+ (UIImage *)thumbnailForTreeItem:(GATreeItem *)treeItem {
    return [[GACacheManager sharedManager] thumbnailForTreeItem:treeItem];
}

+ (void)shouldCacheThumbnails:(BOOL)shouldCacheThumbnails {
    [GACacheManager sharedManager].shouldCacheThumbnails = shouldCacheThumbnails;
}

+ (void)clearThumbnails {
    [[GACacheManager sharedManager] clearThumbnails];
}

#pragma mark - Getters & Setters

- (void)setShouldCacheThumbnails:(BOOL)shouldCacheThumbnails {
    _shouldCacheThumbnails = shouldCacheThumbnails;
    
    if (!shouldCacheThumbnails) {
        [self clearThumbnails];
    }
}

- (NSMutableDictionary *)thumbnails {
    if (!_thumbnails) _thumbnails = [[NSMutableDictionary alloc] init];
    return _thumbnails;
}

#pragma mark - Thumbnails

- (void)clearThumbnails {
    self.thumbnails = nil;
}

- (UIImage *)thumbnailForTreeItem:(GATreeItem *)treeItem {
    UIImage *thumbnail = [self.thumbnails objectForKey:treeItem.path];
    if (thumbnail) return thumbnail;
    
    thumbnail = [self createThumbnailFromImage:[treeItem imageForThumbnail]];
    
    if (thumbnail && self.shouldCacheThumbnails) {
        [self.thumbnails setObject:thumbnail forKey:treeItem.path];
    }
    
    return thumbnail;
}

- (UIImage *)createThumbnailFromImage:(UIImage *)image {
    return image;
}


@end
