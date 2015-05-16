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

- (UIImage *)thumbnailImage {
    return [UIImage imageWithData:self.thumbnail];
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    if ([@[@"jpg", @"jpeg"] containsObject:self.extension.lowercaseString]) {
        self.thumbnail = UIImageJPEGRepresentation(thumbnailImage, 0.5);
    } else if ([@[@"png"] containsObject:self.extension.lowercaseString]) {
        self.thumbnail = UIImagePNGRepresentation(thumbnailImage);
    } else {
        [SRLogger addError:@"Unable to save image as thumbnail %@", thumbnailImage];
    }
}

@end
