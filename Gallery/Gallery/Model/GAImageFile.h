//
//  GAImageFile.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//
#import "GAFile.h"

// Frameworks
#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>



@interface GAImageFile : GAFile

+ (instancetype)imageFileFromPath:(NSString *)path;

+ (BOOL)isImageFile:(NSString *)path;

@end
