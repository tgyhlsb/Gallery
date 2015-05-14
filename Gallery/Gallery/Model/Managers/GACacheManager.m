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
#import "GALogger.h"

static GACacheManager *sharedManager;

@interface GACacheManager()

@property (strong, nonatomic) NSMutableDictionary *thumbnails;
@property (strong, nonatomic) NSMutableArray *thumbnailKeyStack;

@end

@implementation GACacheManager

#pragma mark - Singleton

+ (GACacheManager *)sharedManager {
    if (!sharedManager) {
        sharedManager = [GACacheManager new];
    }
    return sharedManager;
}

+ (UIImage *)thumbnailForFile:(GAFile *)file andSize:(CGSize)size {
    return [[GACacheManager sharedManager] thumbnailForFile:file andSize:size];
}

+ (void)thumbnailForFile:(GAFile *)file andSize:(CGSize)size inBackgroundWithBlock:(GAThumbnailLoadingBlock)block {
    [[GACacheManager sharedManager] thumbnailForFile:file andSize:size inBackgroundWithBlock:block];
}

+ (void)clearThumbnails {
    [[GACacheManager sharedManager] clearThumbnails];
}

#pragma mark - Getters & Setters

- (NSMutableDictionary *)thumbnails {
    if (!_thumbnails) _thumbnails = [[NSMutableDictionary alloc] init];
    return _thumbnails;
}

- (NSMutableArray *)thumbnailKeyStack {
    if (!_thumbnailKeyStack) _thumbnailKeyStack = [[NSMutableArray alloc] init];
    return _thumbnailKeyStack;
}

#pragma mark - Thumbnails

- (void)clearThumbnails {
    self.thumbnails = nil;
    [GALogger addInformation:@"Cache cleared"];
}

- (UIImage *)thumbnailForFile:(GAFile *)file andSize:(CGSize)size {
    NSString *key = [self keyForPath:file.path andSize:size];
    UIImage *thumbnail = [self.thumbnails objectForKey:key];
    if (thumbnail) return thumbnail;
    
    thumbnail = [self createThumbnailFromImage:[file imageForThumbnail] withSize:size];
    [GALogger addInformation:@"New thumbnail\n'%@'", key];
    
    if (thumbnail && [GASettingsManager shouldCacheThumbnails]) {
        [self cacheThumbnail:thumbnail forPath:file.path andSize:size];
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
- (void)thumbnailForFile:(GAFile *)file andSize:(CGSize)size inBackgroundWithBlock:(GAThumbnailLoadingBlock)block {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *thumbnail = [self thumbnailForFile:file andSize:size];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (block) {
                block(thumbnail);
            }
        });
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

- (void)cacheThumbnail:(UIImage *)thumbnail forPath:(NSString *)path andSize:(CGSize)size {
    if (thumbnail) {
        if ([self.thumbnailKeyStack count] >= [GASettingsManager thumbnailCacheLimit]) {
            [self popThumbnail];
        }
        [self pushThumbnail:thumbnail forPath:path andSize:size];
    }
}

- (void)pushThumbnail:(UIImage *)thumbnail forPath:(NSString *)path andSize:(CGSize)size {
    NSString *key = [self keyForPath:path andSize:size];
    [self.thumbnails setObject:thumbnail forKey:key];
    [self.thumbnailKeyStack addObject:key];
}

- (void)popThumbnail {
    NSString *removedThumbnailPath = [self.thumbnailKeyStack firstObject];
    [self.thumbnails removeObjectForKey:removedThumbnailPath];
    [self.thumbnailKeyStack removeObjectAtIndex:0];
}

- (NSString *)keyForPath:(NSString *)path andSize:(CGSize)size {
    return [NSString stringWithFormat:@"%@_%.0fx%.0f", path, size.width, size.height];
}

@end
