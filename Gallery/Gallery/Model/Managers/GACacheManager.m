//
//  GACacheManager.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACacheManager.h"

// Frameworks
#import <UIKit/UIKit.h>

// Managers
#import "GASettingsManager.h"

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
    
    thumbnail = [self createThumbnailFromImage:[file imageForThumbnail] withSize:CGSizeMake(44.0, 44.0)];
    
    if (thumbnail && self.shouldCacheThumbnails) {
        [self cacheThumbnail:thumbnail forPath:file.path];
    }
    
    return thumbnail;
}

// With ImageIO framework
/*
- (CFDictionaryRef)thumbnailOptions {
    CFMutableDictionaryRef options = CFDictionaryCreateMutable(NULL, 2, NULL, NULL);
    CFDictionarySetValue(options, kCGImageSourceThumbnailMaxPixelSize, (__bridge CFNumberRef)@88);
    CFDictionarySetValue(options, kCGImageSourceCreateThumbnailFromImageIfAbsent, (__bridge CFBooleanRef)@YES);
    return options;
}

- (UIImage *)thumbnailForFile:(GAFile *)file {
    if ([file isImage]) {
        CFURLRef url = (__bridge CFURLRef)([NSURL fileURLWithPath:file.path]);
        CGImageSourceRef imageRef =  CGImageSourceCreateWithURL(url, nil);
        CFDictionaryRef options = [self thumbnailOptions];
        CGImageRef thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageRef, 0, options);
        UIImage *thumbnail = [UIImage imageWithCGImage:thumbnailRef];
        return  thumbnail;
    }
    return nil;
}
 */

// Reference http://stackoverflow.com/questions/16283652/understanding-dispatch-async
- (void)thumbnailForFile:(GAFile *)file inBackgroundWithBlock:(GAThumbnailLoadingBlock)block {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *thumbnail = [self thumbnailForFile:file];
        if (block) {
            block(thumbnail);
        }
    });
}

- (UIImage *)createThumbnailFromImage:(UIImage *)image withSize:(CGSize)size {
//    Calcul thumbnail size
    CGFloat ratio = MIN(size.width/image.size.width, size.height/image.size.height);
    CGSize targetSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    
//    Create thumbnail
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return destImage;
}

- (void)cacheThumbnail:(UIImage *)thumbnail forPath:(NSString *)path {
    if (thumbnail) {
        if ([self.thumbnailPathStack count] >= [GASettingsManager thumbnailCacheLimit]) {
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
