//
//  SRDirectory+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDirectory+Helper.h"

@implementation SRDirectory (Helper)

- (BOOL)isDirectory {
    return YES;
}

#pragma mark - File type

+ (BOOL)fileAtPathIsDirectory:(NSString *)path {
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory;
}

@end
