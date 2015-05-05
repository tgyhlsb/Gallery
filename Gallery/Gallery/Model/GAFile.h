//
//  GAFile.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface GAFile : NSObject

@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) UIImage *thumbnail;
@property (nonatomic) BOOL shouldCache;

- (id)initFromPath:(NSString *)path;

- (NSString *)nameWithExtension:(BOOL)extension;
- (UIImage *)imageForThumbnail;

- (BOOL)isDirectory;
- (BOOL)isImage;

@end
