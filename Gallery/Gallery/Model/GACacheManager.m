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
@property (strong, nonatomic) NSMutableArray *thumbnailPathStack;

@end

@implementation GACacheManager

#pragma mark - Singleton

+ (GACacheManager *)sharedManager {
    if (!sharedManager) {
        sharedManager = [GACacheManager new];
        sharedManager.shouldCacheThumbnails = YES;
        sharedManager.thumbnailCacheLimit = 50;
    }
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

- (NSMutableArray *)thumbnailPathStack {
    if (!_thumbnailPathStack) _thumbnailPathStack = [[NSMutableArray alloc] init];
    return _thumbnailPathStack;
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
        [self cacheThumbnail:thumbnail forPath:treeItem.path];
    }
    
    return thumbnail;
}

- (UIImage *)createThumbnailFromImage:(UIImage *)image {
    return image;
}

- (void)cacheThumbnail:(UIImage *)thumbnail forPath:(NSString *)path {
    if (thumbnail) {
        if ([self.thumbnailPathStack count] >= self.thumbnailCacheLimit) {
            [self popThumbnail];
        }
        [self pushThumbnail:thumbnail forPath:path];
    }
}

- (void)pushThumbnail:(UIImage *)thumbnail forPath:(NSString *)path {
    [self.thumbnails setObject:thumbnail forKey:path];
    [self.thumbnailPathStack addObject:path];
}

- (void)popThumbnail {
    NSString *removedThumbnailPath = [self.thumbnailPathStack firstObject];
    [self.thumbnails removeObjectForKey:removedThumbnailPath];
    [self.thumbnailPathStack removeObjectAtIndex:0];
}

@end
