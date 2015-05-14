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

#define KEY_USER_SETTINGS_EXIST @"GASettingsManagerUserSettingsExist"

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

@interface GASettingsManager()

@property (nonatomic) BOOL userSettingsExist;

@property (nonatomic) UIViewContentMode thumbnailMode;
@property (nonatomic) NSInteger thumbnailCacheLimit;
@property (nonatomic) BOOL shouldCacheThumbnails;
@property (nonatomic) GASettingDirectoryNavigationMode navigationMode;
@property (nonatomic) NSInteger pictureNumberPortrait;
@property (nonatomic) NSInteger pictureNumberLandscape;

@end

@implementation GASettingsManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    if (!sharedManager) {
        sharedManager = [GASettingsManager new];
        NSNumber *userSettingsExist = [sharedManager objectForKey:KEY_USER_SETTINGS_EXIST];
        if ([userSettingsExist boolValue]) {
            [sharedManager loadFromUserSettings];
        } else {
            [sharedManager loadDefaultValues];
        }
    }
    return sharedManager;
}

#pragma  mark - NSUserDefault management

- (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

- (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)loadFromUserSettings {
    _userSettingsExist = [[self objectForKey:KEY_USER_SETTINGS_EXIST] boolValue];
    _thumbnailMode = [[self objectForKey:KEY_THUMBNAIL_MODE] integerValue];
    _thumbnailCacheLimit = [[self objectForKey:KEY_THUMBNAIL_CACHE_LIMIT] integerValue];
    _shouldCacheThumbnails = [[self objectForKey:KEY_THUMBNAIL_SHOULD_CACHE] boolValue];
    _navigationMode = [[self objectForKey:KEY_DIRECTORY_NAVIGATION_MODE] integerValue];
    _pictureNumberPortrait = [[self objectForKey:KEY_PICTURE_NUMBER_PORTRAIT] integerValue];
    _pictureNumberLandscape = [[self objectForKey:KEY_PICTURE_NUMBER_LANDSCAPE] integerValue];
}

- (void)loadDefaultValues {
    _thumbnailMode = DEFAULT_THUMBNAIL_MODE;
    _thumbnailCacheLimit = DEFAULT_THUMBNAIL_CACHE_LIMIT;
    _shouldCacheThumbnails = DEFAULT_THUMBNAIL_SHOULD_CACHE;
    _navigationMode = DEFAULT_DIRECTORY_NAVIGATION_MODE;
    _pictureNumberPortrait = DEFAULT_PICTURE_NUMBER_PORTRAIT;
    _pictureNumberLandscape = DEFAULT_PICTURE_NUMBER_LANDSCAPE;
}

- (void)synchronize {
    self.userSettingsExist = YES;
    [self setValue:@(self.userSettingsExist) forKey:KEY_USER_SETTINGS_EXIST];
    
    [self setValue:@(self.thumbnailMode) forKey:KEY_THUMBNAIL_MODE];
    [self setValue:@(self.thumbnailCacheLimit) forKey:KEY_THUMBNAIL_CACHE_LIMIT];
    [self setValue:@(self.shouldCacheThumbnails) forKey:KEY_THUMBNAIL_SHOULD_CACHE];
    [self setValue:@(self.navigationMode) forKey:KEY_DIRECTORY_NAVIGATION_MODE];
    [self setValue:@(self.pictureNumberPortrait) forKey:KEY_PICTURE_NUMBER_PORTRAIT];
    [self setValue:@(self.pictureNumberLandscape) forKey:KEY_PICTURE_NUMBER_LANDSCAPE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getters & Setters

#pragma mark Class

+ (UIViewContentMode)thumbnailMode {
    return [GASettingsManager sharedManager].thumbnailMode;
}

+ (void)setThumbnailMode:(UIViewContentMode)thumbnailMode {
    [[GASettingsManager sharedManager] setThumbnailMode:thumbnailMode];
}

+ (BOOL)shouldCacheThumbnails {
    return [GASettingsManager sharedManager].shouldCacheThumbnails;
}

+ (void)setShouldCacheThumbnails:(BOOL)shouldCacheThumbnails {
    [[GASettingsManager sharedManager] setShouldCacheThumbnails:shouldCacheThumbnails];
}

+ (NSInteger)thumbnailCacheLimit {
    return [GASettingsManager sharedManager].thumbnailCacheLimit;
}

+ (void)setTumbnailCacheLimit:(NSInteger)cacheLimit {
    [[GASettingsManager sharedManager] setThumbnailCacheLimit:cacheLimit];
}

+ (GASettingDirectoryNavigationMode)directoryNavigationMode {
    return [GASettingsManager sharedManager].navigationMode;
}

+ (void)setDirectoryNavigationMode:(GASettingDirectoryNavigationMode)mode {
    [[GASettingsManager sharedManager] setNavigationMode:mode];
}

+ (NSInteger)pictureNumberPortrait {
    return [GASettingsManager sharedManager].pictureNumberPortrait;
}

+ (void)setPictureNumberPortrait:(NSInteger)pictureNumber {
    [[GASettingsManager sharedManager] setPictureNumberPortrait:pictureNumber];
}

+ (NSInteger)pictureNumberLandscape {
    return [GASettingsManager sharedManager].pictureNumberLandscape;
}

+ (void)setPictureNumberLandscape:(NSInteger)pictureNumber {
    [[GASettingsManager sharedManager] setPictureNumberLandscape:pictureNumber];
}

#pragma mark Instance

- (void)setThumbnailMode:(UIViewContentMode)thumbnailMode {
    _thumbnailMode = thumbnailMode;
    [self synchronize];
}

- (void)setThumbnailCacheLimit:(NSInteger)thumbnailCacheLimit {
    _thumbnailCacheLimit = thumbnailCacheLimit;
    [self synchronize];
}

- (void)setShouldCacheThumbnails:(BOOL)shouldCacheThumbnails {
    _shouldCacheThumbnails = shouldCacheThumbnails;
    [self synchronize];
}

- (void)setNavigationMode:(GASettingDirectoryNavigationMode)navigationMode {
    _navigationMode = navigationMode;
    [self synchronize];
}

- (void)setPictureNumberPortrait:(NSInteger)pictureNumberPortrait {
    _pictureNumberPortrait = pictureNumberPortrait;
    [self synchronize];
}

- (void)setPictureNumberLandscape:(NSInteger)pictureNumberLandscape {
    _pictureNumberLandscape = pictureNumberLandscape;
    [self synchronize];
}

@end
