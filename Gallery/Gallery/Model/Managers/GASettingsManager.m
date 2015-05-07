//
//  GASettingsManager.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsManager.h"

#define KEY_THUMBNAIL_MODE @"GAThumbnailMode"
#define DEFAULT_THUMBNAIL_MODE UIViewContentModeScaleAspectFill

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

@end
