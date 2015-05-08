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
@property (weak, nonatomic, readonly) GAFile *parent;
@property (weak, nonatomic, readonly) GAFile *next;
@property (weak, nonatomic, readonly) GAFile *previous;

@property (nonatomic) BOOL shouldCache;

- (id)initFromPath:(NSString *)path
            parent:(GAFile *)parent;

- (void)setNext:(GAFile *)next;
- (void)setPrevious:(GAFile *)previous;

- (NSString *)nameWithExtension:(BOOL)extension;
- (UIImage *)imageForThumbnail;

- (BOOL)isDirectory;
- (BOOL)isImage;

@end
