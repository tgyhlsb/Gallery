//
//  GAImageFile.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import "GATreeItem.h"

// Frameworks
#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>



@interface GAImageFile : GATreeItem

@property (strong, nonatomic, readonly) UIImage *image;

+ (instancetype)imageFileFromPath:(NSString *)path;

+ (BOOL)isImageFile:(NSString *)path;

@end
