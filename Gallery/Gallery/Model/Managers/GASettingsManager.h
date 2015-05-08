//
//  GASettingsManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GASettingsManager : NSObject

+ (UIViewContentMode)thumbnailMode;
+ (void)setThumbnailMode:(UIViewContentMode)thumbnailMode;

+ (NSInteger)thumbnailCacheLimit;
+ (void)setTumbnailCacheLimit:(NSInteger)cacheLimit;

@end
