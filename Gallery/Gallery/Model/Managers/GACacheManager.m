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
        sharedManager.shouldCacheThumbnails = NO;
        sharedManager.thumbnailCacheLimit = 50;
    }
    return sharedManager;
}

+ (UIImage *)thumbnailForFile:(GAFile *)file {
    return [[GACacheManager sharedManager] thumbnailForFile:file];
}

+ (void)thumbnailForFile:(GAFile *)file inBackgroundWithBlock:(GAThumbnailLoadingBlock)block {
    [[GACacheManager sharedManager] thumbnailForFile:file inBackgroundWithBlock:block];
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

- (UIImage *)thumbnailForFile:(GAFile *)file {
    UIImage *thumbnail = [self.thumbnails objectForKey:file.path];
    if (thumbnail) return thumbnail;
    
    thumbnail = [self createThumbnailFromImage:[file imageForThumbnail]];
    
    if (thumbnail && self.shouldCacheThumbnails) {
        [self cacheThumbnail:thumbnail forPath:file.path];
    }
    
    return thumbnail;
}

// Reference http://stackoverflow.com/questions/16283652/understanding-dispatch-async
- (void)thumbnailForFile:(GAFile *)file inBackgroundWithBlock:(GAThumbnailLoadingBlock)block {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *thumbnail = [self thumbnailForFile:file];
        if (block) {
            block(thumbnail);
        }
    });
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
