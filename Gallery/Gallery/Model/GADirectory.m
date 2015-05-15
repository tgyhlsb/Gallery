//
//  GADirectory.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectory.h"

// Managers
#import "GALogger.h"
#import "GACacheManager.h"

// Models
#import "GAImageFile.h"

@interface GADirectory()

@property (strong, nonatomic, readwrite) NSArray *tree;
@property (strong, nonatomic, readwrite) NSArray *images;
@property (strong, nonatomic, readwrite) NSArray *directories;
@property (strong, nonatomic, readwrite) NSArray *recursiveImages;
@property (strong, nonatomic, readwrite) NSArray *recursiveDirectories;

@end

@implementation GADirectory

#pragma mark - Contructors 

+ (instancetype)directoryFromPath:(NSString *)path
                           parent:(GADirectory *)parent {
    
    return [[GADirectory alloc] initFromPath:path parent:parent];
}

- (id)initFromPath:(NSString *)path
            parent:(GADirectory *)parent {
    
    self = [super initFromPath:path parent:parent];
    if (self) {
        self.tree = [self readTreeFromPath:path];
    }
    return self;
}

#pragma mark - Getters & Setters

- (UIImage *)imageForThumbnail {
    return nil;
}

- (BOOL)isDirectory {
    return YES;
}

#pragma mark - Helpers

+ (BOOL)isDirectory:(NSString *)path {
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    return isDirectory;
}

#pragma mark - Factory

- (NSArray *)readTreeFromPath:(NSString *)path {
    
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (files == nil) {
        [GALogger addError:@"Error reading contents of documents directory: %@", [error localizedDescription]];
    }
    
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *directories = [[NSMutableArray alloc] init];
    NSMutableArray *recursiveImages = [[NSMutableArray alloc] init];
    NSMutableArray *recursiveDirectories = [[NSMutableArray alloc] init];
    
    NSString *fullPath = nil;
    
    GAFile *previous = nil;
    
    for (NSString *file in files) {
        fullPath = [path stringByAppendingPathComponent:file];
        if ([GAImageFile isImageFile:fullPath]) {
            
            GAImageFile *imageFile = [GAImageFile imageFileFromPath:fullPath parent:self];
            [imageFile setPrevious:previous];
            [previous setNext:imageFile];
            [tree addObject:imageFile];
            [images addObject:imageFile];
            
        } else if ([GADirectory isDirectory:fullPath]) {
            
            GADirectory *directory = [GADirectory directoryFromPath:fullPath parent:self];
            [directory setPrevious:previous];
            [previous setNext:directory];
            [tree addObject:directory];
            [directories addObject:directory];
            [recursiveDirectories addObject:directory];
            [recursiveDirectories addObjectsFromArray:directory.recursiveDirectories];
            [recursiveImages addObjectsFromArray:directory.images];
            [recursiveImages addObjectsFromArray:directory.recursiveImages];
            
        } else {
            [GALogger addError:@"Failed to read : %@", file];
        }
    }
    
    self.images = images;
    self.directories = directories;
    self.recursiveImages = recursiveImages;
    self.recursiveDirectories = recursiveDirectories;
    
    return tree;
}

- (void)preloadImageThumbnail:(GAImageFile *)imageFile {
    [GACacheManager thumbnailForFile:imageFile andSize:CGSizeMake(200, 200) inBackgroundWithBlock:^(UIImage *thumbnail) {
        
    }];
}



@end
