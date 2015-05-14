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
        [GADirectory newObject:self];
        self.tree = [self readTreeFromPath:path];
    }
    return self;
}

#pragma mark - Factory

static NSMutableArray *existingObjects;

+ (NSMutableArray *)existingObjects {
    if (!existingObjects) {
        existingObjects = [[NSMutableArray alloc] init];
    }
    return existingObjects;
}

+ (void)newObject:(GADirectory *)imageFile {
    [[self existingObjects] addObject:imageFile];
}

+ (void)deleteObject:(GADirectory *)imageFile {
    [[self existingObjects] removeObject:imageFile];
}

- (void)dealloc {
    [GADirectory deleteObject:self];
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
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *directories = [[NSMutableArray alloc] init];
    NSString *fullPath = nil;
    
    GAFile *previous = nil;
    GAImageFile *previousImage = nil;
    GADirectory *previousDirectory = nil;
    
    for (NSString *file in files) {
        fullPath = [self.path stringByAppendingPathComponent:file];
        if ([GAImageFile isImageFile:fullPath]) {
            
            GAImageFile *imageFile = [GAImageFile imageFileFromPath:fullPath parent:self];
            [imageFile setPrevious:previous];
            [previous setNext:imageFile];
            [tree addObject:imageFile];
            [images addObject:imageFile];
            previous = imageFile;
            previousImage = imageFile;
            
        } else if ([GADirectory isDirectory:fullPath]) {
            
            GADirectory *directory = [GADirectory directoryFromPath:fullPath parent:self];
            [directory setPrevious:previous];
            [previous setNext:directory];
            [tree addObject:directory];
            [directories addObject:directory];
            previous = directory;
            previousDirectory = directory;
            
        } else {
            [GALogger addError:@"Failed to read : %@", file];
        }
    }
    
    self.images = images;
    self.directories = directories;
    self.recursiveImages = images;
    self.recursiveDirectories = directories;
    
    return tree;
}

@end
