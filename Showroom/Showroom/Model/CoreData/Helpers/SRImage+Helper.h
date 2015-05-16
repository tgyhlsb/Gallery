//
//  SRImage+Helper.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImage.h"
#import <UIKit/UIKit.h>
#import "SRFile+Helper.h"

@interface SRImage (Helper)

+ (BOOL)fileAtPathIsImage:(NSString *)path;

- (UIImage *)thumbnail;
- (void)setThumbnail:(UIImage *)thumbnail;
- (UIImage *)image;
- (void)setImage:(UIImage *)image;

@end
