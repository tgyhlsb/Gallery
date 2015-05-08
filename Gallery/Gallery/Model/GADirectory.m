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

// Models
#import "GAImageFile.h"

@interface GADirectory()

@property (strong, nonatomic, readwrite) NSArray *tree;
@property (weak, nonatomic, readwrite) GAFile *firstChild;
@property (weak, nonatomic, readwrite) GAImageFile *firstImage;
@property (weak, nonatomic, readwrite) GADirectory *firstDirectory;

@end

@implementation GADirectory

#pragma mark - Contructors 

+ (instancetype)directoryFromPath:(NSString *)path
                           parent:(GAFile *)parent {
    
    return [[GADirectory alloc] initFromPath:path parent:parent];
}

- (id)initFromPath:(NSString *)path
            parent:(GAFile *)parent {
    
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

- (NSArray *)readTreeFromPath:(NSString *)path {
    
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (files == nil) {
        [GALogger addError:@"Error reading contents of documents directory: %@", [error localizedDescription]];
    }
    
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    NSString *fullPath = nil;
    
    GAFile *previous = nil;
    BOOL isFirstChild = YES;
    BOOL isFirstImage = YES;
    BOOL isFirstDirectory = YES;
    
    for (NSString *file in files) {
        fullPath = [self.path stringByAppendingPathComponent:file];
        if ([GAImageFile isImageFile:fullPath]) {
            
            GAImageFile *imageFile = [GAImageFile imageFileFromPath:fullPath parent:self];
            [imageFile setPrevious:previous];
            [previous setNext:imageFile];
            if (isFirstChild) self.firstChild = imageFile;
            if (isFirstImage) self.firstImage = imageFile;
            [tree addObject:imageFile];
            
        } else if ([GADirectory isDirectory:fullPath]) {
            
            GADirectory *directory = [GADirectory directoryFromPath:fullPath parent:self];
            [directory setPrevious:previous];
            [previous setNext:directory];
            if (isFirstChild) self.firstChild = directory;
            if (isFirstDirectory) self.firstDirectory = directory;
            [tree addObject:directory];
            
        } else {
            [GALogger addError:@"Failed to read : %@", file];
        }
    }
    
    return tree;
}

@end
