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
@property (weak, nonatomic, readwrite) GAFile *lastChild;
@property (weak, nonatomic, readwrite) GAImageFile *firstImage;
@property (weak, nonatomic, readwrite) GAImageFile *lastImage;
@property (weak, nonatomic, readwrite) GADirectory *firstDirectory;
@property (weak, nonatomic, readwrite) GADirectory *lastDirectory;

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

- (NSArray *)readTreeFromPath:(NSString *)path {
    
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (files == nil) {
        [GALogger addError:@"Error reading contents of documents directory: %@", [error localizedDescription]];
    }
    
    NSMutableArray *tree = [[NSMutableArray alloc] init];
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
            if (!self.firstChild) self.firstChild = imageFile;
            if (!self.firstImage) self.firstImage = imageFile;
            [tree addObject:imageFile];
            previous = imageFile;
            previousImage = imageFile;
            
        } else if ([GADirectory isDirectory:fullPath]) {
            
            GADirectory *directory = [GADirectory directoryFromPath:fullPath parent:self];
            [directory setPrevious:previous];
            [previous setNext:directory];
            if (!self.firstChild) self.firstChild = directory;
            if (!self.firstDirectory) self.firstDirectory = directory;
            [tree addObject:directory];
            previous = directory;
            previousDirectory = directory;
            
        } else {
            [GALogger addError:@"Failed to read : %@", file];
        }
    }
    self.lastChild = previous;
    self.lastImage = previousImage;
    self.lastDirectory = previousDirectory;
    
    [self.firstChild setPrevious:self.lastChild];
    [self.lastChild setNext:self.firstChild];
    
    return tree;
}

@end
