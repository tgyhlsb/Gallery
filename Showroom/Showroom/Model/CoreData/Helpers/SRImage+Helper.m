//
//  SRImage+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImage+Helper.h"

@implementation SRImage (Helper)

- (BOOL)isImage {
    return YES;
}

#pragma mark - File type

+ (BOOL)fileAtPathIsImage:(NSString *)path {
    NSString *extension = [path pathExtension];
    return [@[@"jpg", @"png", @"jpeg"] containsObject:extension.lowercaseString];
}

@end
