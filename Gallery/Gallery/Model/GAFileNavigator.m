//
//  GAFileNavigator.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 14/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFileNavigator.h"

// Managers
#import "GASettingsManager.h"

@interface GAFileNavigator()

@property (strong, nonatomic) GADirectory *rootDirectory;
@property (strong, nonatomic) GAFile *activeFile;

@end

@implementation GAFileNavigator

#pragma mark - Constructor

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory {
    return [[GAFileNavigator alloc] initWithRootDirectory:rootDirectory];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory {
    self = [super init];
    if (self) {
        self.rootDirectory = rootDirectory;
    }
    return self;
}

#pragma mark - Getters & Setters

- (void)setActiveFile:(GAFile *)activeFile {
    _activeFile = activeFile;
}

- (void)setRootDirectory:(GADirectory *)rootDirectory {
    _rootDirectory = rootDirectory;
}

#pragma API

- (void)setDirectory:(GADirectory *)directory {
    self.rootDirectory = directory;
}

- (void)selectDirectory:(GADirectory *)directory {
    [self notifyDidSelectDirectory:directory];
    [self setDirectory:directory];
}

- (void)setFile:(GAFile *)file {
    self.activeFile = file;
}

- (void)selectFile:(GAFile *)file {
    [self notifyDidSelectFile:file];
    [self setFile:file];
}

- (GAFile *)getFile {
    return self.activeFile;
}

- (GAFile *)getNextFile {
    GAFile *nextFile = [self findFileAfterFile:self.activeFile];
    if (nextFile) return nextFile;
    
    return nil;
}

- (GAFile *)getPreviousFile {
    GAFile *previousFile = [self findFileBeforeFile:self.activeFile];
    if (previousFile) return previousFile;
    
    return nil;
}

- (GADirectory *)getRootDirectory {
    return self.rootDirectory;
}

#pragma mark - Helpers

- (GAFile *)findFileAfterFile:(GAFile *)file {
    GAFile *next = nil;
    switch ([GASettingsManager navigationFileType]) {
        case GASettingNavigationFileTypeAll:
            next = [file next]; break;
        case GASettingNavigationFileTypeImages:
            next = [file nextImage]; break;
        case GASettingNavigationFileTypeDirectories:
            next = [file nextDirectory]; break;
    }
    return [next isEqual:file] ? nil : next;
}


- (GAFile *)findFileBeforeFile:(GAFile *)file {
    GAFile *previous = nil;
    switch ([GASettingsManager navigationFileType]) {
        case GASettingNavigationFileTypeAll:
            previous = [file previous]; break;
        case GASettingNavigationFileTypeImages:
            previous = [file previousImage]; break;
        case GASettingNavigationFileTypeDirectories:
            previous = [file previousDirectory]; break;
    }
    return [previous isEqual:file] ? nil : previous;
}

#pragma mark - Delegate

- (void)notifyDidSelectFile:(GAFile *)file {
//    if ([self.delegate respondsToSelector:@selector(fileNavigator:didSelectFile:)]) {
//        [self.delegate fileNavigator:self didSelectFile:file];
//    }
    
    if (file.isImage) {
        [self notifyDidSelectImageFile:(GAImageFile *)file];
    } else if (file.isDirectory) {
        [self notifyDidSelectDirectory:(GADirectory *)file];
    } else {
        
    }
}

#pragma mark - Broadcast

- (void)notifyDidSelectDirectory:(GADirectory *)directory {
    [[NSNotificationCenter defaultCenter] postNotificationName:GANotificationFileNavigatorDidSelectDirectory
                                                        object:self
                                                      userInfo:@{@"directory": directory}];
}

- (void)notifyDidSelectImageFile:(GAImageFile *)imageFile {
    [[NSNotificationCenter defaultCenter] postNotificationName:GANotificationFileNavigatorDidSelectImageFile
                                                        object:self
                                                      userInfo:@{@"imageFile": imageFile}];
}

@end
