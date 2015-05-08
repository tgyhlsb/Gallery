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

#define KEY_DIRECTORY_NAVIGATION_MODE @"GASettingDirectoryNavigationMode"
#define DEFAULT_DIRECTORY_NAVIGATION_MODE GASettingDirectoryNavigationModeShowFirstImage

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

@end
