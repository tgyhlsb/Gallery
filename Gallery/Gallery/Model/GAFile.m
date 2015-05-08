//
//  GAFile.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFile.h"

@interface GAFile()

@property (strong, nonatomic, readwrite) NSString *path;
@property (strong, nonatomic, readwrite) UIImage *thumbnail;
@property (weak, nonatomic, readwrite) GADirectory *parent;
@property (weak, nonatomic, readwrite) GAFile *next;
@property (weak, nonatomic, readwrite) GAFile *previous;

@end

@implementation GAFile

#pragma mark - Constructors


- (id)initFromPath:(NSString *)path
            parent:(GADirectory *)parent {
    
    self = [super init];
    if (self) {
        self.path = path;
        self.parent = parent;
    }
    return self;
}

#pragma mark - Getters

- (NSString *)nameWithExtension:(BOOL)extension {
    return extension ? [self.path lastPathComponent] : [[self.path lastPathComponent] stringByDeletingPathExtension];
}

- (UIImage *)imageForThumbnail {
    return nil;
}

- (BOOL)isDirectory {
    return NO;
}

- (BOOL)isImage {
    return NO;
}


@end
