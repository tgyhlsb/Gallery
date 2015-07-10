//
//  SRImage+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImage+Helper.h"

// Managers
#import "SRLogger.h"

@implementation SRImage (Helper)

- (BOOL)isImage {
    return YES;
}

#pragma mark - File type

+ (BOOL)fileAtPathIsImage:(NSString *)path {
    NSString *extension = [path pathExtension];
    return [@[@"jpg", @"png", @"jpeg"] containsObject:extension.lowercaseString];
}

#pragma mark - Thumbnails

- (UIImage *)thumbnail {
    return [UIImage imageWithData:self.thumbnailData];
}

- (void)setThumbnail:(UIImage *)thumbnail {
    if ([@[@"jpg", @"jpeg"] containsObject:self.extension.lowercaseString]) {
        self.thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.5);
    } else if ([@[@"png"] containsObject:self.extension.lowercaseString]) {
        self.thumbnailData = UIImagePNGRepresentation(thumbnail);
    } else {
        [SRLogger addError:@"Unable to save image as thumbnail %@", thumbnail];
    }
}

- (UIImage *)image {
//    return [UIImage imageWithData:self.imageData];
    return [UIImage imageWithContentsOfFile:[self absolutePath]];
}

- (void)setImage:(UIImage *)image {
//    if ([@[@"jpg", @"jpeg"] containsObject:self.extension.lowercaseString]) {
//        self.imageData = UIImageJPEGRepresentation(image, 0.5);
//    } else if ([@[@"png"] containsObject:self.extension.lowercaseString]) {
//        self.imageData = UIImagePNGRepresentation(image);
//    } else {
//        [SRLogger addError:@"Unable to save image %@", image];
//    }
}

@end
