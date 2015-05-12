//
//  GASettingsManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GASettingDirectoryNavigationMode){
    GASettingDirectoryNavigationModeIgnore,
    GASettingDirectoryNavigationModeShowDirectory,
    GASettingDirectoryNavigationModeShowFirstImage
};

@interface GASettingsManager : NSObject

+ (UIViewContentMode)thumbnailMode;
+ (void)setThumbnailMode:(UIViewContentMode)thumbnailMode;

+ (NSInteger)thumbnailCacheLimit;
+ (void)setTumbnailCacheLimit:(NSInteger)cacheLimit;

+ (BOOL)shouldCacheThumbnails;
+ (void)setShouldCacheThumbnails:(BOOL)shouldCacheThumbnails;

+ (GASettingDirectoryNavigationMode)directoryNavigationMode;
+ (void)setDirectoryNavigationMode:(GASettingDirectoryNavigationMode)mode;

+ (NSInteger)pictureNumberPortrait;
+ (void)setPictureNumberPortrait:(NSInteger)pictureNumber;

+ (NSInteger)pictureNumberLandscape;
+ (void)setPictureNumberLandscape:(NSInteger)pictureNumber;


@end
