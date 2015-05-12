//
//  GASettingsManager.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsManager.h"

// Managers
#import "GACacheManager.h"

#define KEY_THUMBNAIL_MODE @"GAThumbnailMode"
#define DEFAULT_THUMBNAIL_MODE UIViewContentModeScaleAspectFill

#define KEY_THUMBNAIL_CACHE_LIMIT @"GAThumbnailCacheLimit"
#define DEFAULT_THUMBNAIL_CACHE_LIMIT 100

#define KEY_THUMBNAIL_SHOULD_CACHE @"GAShouldCacheThumbnails"
#define DEFAULT_THUMBNAIL_SHOULD_CACHE YES

#define KEY_DIRECTORY_NAVIGATION_MODE @"GASettingDirectoryNavigationMode"
#define DEFAULT_DIRECTORY_NAVIGATION_MODE GASettingDirectoryNavigationModeShowFirstImage

#define KEY_PICTURE_NUMBER_PORTRAIT @"GAPictureNumberPortrait"
#define DEFAULT_PICTURE_NUMBER_PORTRAIT 4

#define KEY_PICTURE_NUMBER_LANDSCAPE @"GAPictureNumberLandscape"
#define DEFAULT_PICTURE_NUMBER_LANDSCAPE 6

static GASettingsManager *sharedManager;

@implementation GASettingsManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    if (!sharedManager) {
        sharedManager = [GASettingsManager new];
    }
    return sharedManager;
}

#pragma  mark - NSUserDefault management

- (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Getters & Setters

+ (UIViewContentMode)thumbnailMode {
    NSNumber *value = [[GASettingsManager sharedManager] objectForKey:KEY_THUMBNAIL_MODE];
    return value ? [value integerValue] : DEFAULT_THUMBNAIL_MODE;
}

+ (void)setThumbnailMode:(UIViewContentMode)thumbnailMode {
    [[GASettingsManager sharedManager] setValue:@(thumbnailMode) forKey:KEY_THUMBNAIL_MODE];
}

+ (BOOL)shouldCacheThumbnails {
    NSNumber *value = [[GASettingsManager sharedManager] objectForKey:KEY_THUMBNAIL_SHOULD_CACHE];
    return value ? [value boolValue] : DEFAULT_THUMBNAIL_SHOULD_CACHE;
}

+ (void)setShouldCacheThumbnails:(BOOL)shouldCacheThumbnails {
    [[GASettingsManager sharedManager] setValue:@(shouldCacheThumbnails) forKey:KEY_THUMBNAIL_SHOULD_CACHE];
}

+ (NSInteger)thumbnailCacheLimit {
    NSNumber *value = [[GASettingsManager sharedManager] objectForKey:KEY_THUMBNAIL_CACHE_LIMIT];
    return value ? [value integerValue] : DEFAULT_THUMBNAIL_CACHE_LIMIT;
}

+ (void)setTumbnailCacheLimit:(NSInteger)cacheLimit {
    [[GASettingsManager sharedManager] setValue:@(cacheLimit) forKey:KEY_THUMBNAIL_CACHE_LIMIT];
}

+ (GASettingDirectoryNavigationMode)directoryNavigationMode {
    NSNumber *value = [[GASettingsManager sharedManager] objectForKey:KEY_DIRECTORY_NAVIGATION_MODE];
    return value ? [value integerValue] : DEFAULT_DIRECTORY_NAVIGATION_MODE;
}

+ (void)setDirectoryNavigationMode:(GASettingDirectoryNavigationMode)mode {
    [[GASettingsManager sharedManager] setValue:@(mode) forKey:KEY_DIRECTORY_NAVIGATION_MODE];
}

+ (NSInteger)pictureNumberPortrait {
    NSNumber *value = [[GASettingsManager sharedManager] objectForKey:KEY_PICTURE_NUMBER_PORTRAIT];
    return value ? [value integerValue] : DEFAULT_PICTURE_NUMBER_PORTRAIT;
}

+ (void)setPictureNumberPortrait:(NSInteger)pictureNumber {
    [[GASettingsManager sharedManager] setValue:@(pictureNumber) forKey:KEY_PICTURE_NUMBER_PORTRAIT];
}

+ (NSInteger)pictureNumberLandscape {
    NSNumber *value = [[GASettingsManager sharedManager] objectForKey:KEY_PICTURE_NUMBER_LANDSCAPE];
    return value ? [value integerValue] : DEFAULT_PICTURE_NUMBER_LANDSCAPE;
}

+ (void)setPictureNumberLandscape:(NSInteger)pictureNumber {
    [[GASettingsManager sharedManager] setValue:@(pictureNumber) forKey:KEY_PICTURE_NUMBER_LANDSCAPE];
}

@end
