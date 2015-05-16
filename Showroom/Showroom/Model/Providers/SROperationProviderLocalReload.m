//
//  SROperationProviderLocalReload.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SROperationProviderLocalReload.h"

// Provider
#import "SRProviderLocal.h"

// Managers
#import "SRLogger.h"

// Models
#import "SRFile+Serializer.h"
#import "SRFile+Helper.h"
#import "SRImage+Serializer.h"
#import "SRImage+Helper.h"
#import "SRDirectory+Serializer.h"
#import "SRDirectory+Helper.h"

@interface SROperationProviderLocalReload()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *parentManagedObjectContext;

@end

@implementation SROperationProviderLocalReload

#pragma mark - Constructor

- (id)initWithParentManagedObjectContext:(NSManagedObjectContext *)parentManagedObjectContext {
    self= [super init];
    if (self) {
        self.queuePriority = NSOperationQueuePriorityHigh;
        self.qualityOfService = NSQualityOfServiceBackground;
        
        _parentManagedObjectContext = parentManagedObjectContext;
    }
    return self;
}

#pragma mark - Getters & Setters

- (NSManagedObjectContext *)privateManagedObjectContext {
    if (!_privateManagedObjectContext) {
        _privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_privateManagedObjectContext setParentContext:_parentManagedObjectContext];
    }
    return _privateManagedObjectContext;
}

#pragma mark - Main

- (void)main {
    // Initialize Managed Object Context
    self.privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    // Configure Managed Object Context
    [self.privateManagedObjectContext setParentContext:self.parentManagedObjectContext];
    
    // Do Some Work
    // ...
    [self reloadFiles];
    
    if ([self.privateManagedObjectContext hasChanges]) {
        // Save Changes
        NSError *error = nil;
        [self.privateManagedObjectContext save:&error];
    }
}

- (void)reloadFiles {
    NSString *absolutePath = [SRProviderLocal absolutePath:self.directory.path];
    NSInteger depth = [self.directory.depth integerValue];
    [self directoryFromPath:absolutePath recursively:self.recursively depth:depth];
    if (self.completionBlock) {
        self.completionBlock();
    }
}

- (SRDirectory *)directoryFromPath:(NSString *)path recursively:(BOOL)recursively depth:(NSInteger)depth {
    
    NSDictionary *attributes = [SRProviderLocal getAttributesForFileAtPath:path];
    NSString *relativePath = [SRProviderLocal relativePath:path];
    
    SRDirectory *rootDirectory = [SRDirectory directoryWithPath:relativePath
                                                     attributes:attributes
                                                          depth:depth
                                                       provider:SRProviderTypeLocal
                                         inManagedObjectContext:self.privateManagedObjectContext];
    
    if (recursively) {
        [self readFilesForDirectory:rootDirectory recursively:(BOOL)recursively depth:depth+1];
    }
    
    return rootDirectory;
}

- (SRImage *)imageFromPath:(NSString *)path depth:(NSInteger)depth {
    
    NSDictionary *attributes = [SRProviderLocal getAttributesForFileAtPath:path];
    NSString *relativePath = [SRProviderLocal relativePath:path];
    
    return [SRImage imageWithPath:relativePath
                       attributes:attributes
                            depth:depth
                         provider:SRProviderTypeLocal
           inManagedObjectContext:self.privateManagedObjectContext];
}

- (void)cleanCoreData {
    
    NSFetchRequest *request = [SRProvider requestForFilesForProvider:SRProviderTypeLocal];
    
    NSError *error = nil;
    NSArray *matches = [self.privateManagedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        [SRLogger addError:@"Failed fetching local root directory. Error: '%@'", error];
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (SRFile *file in matches) {
            NSString *absolutePath = [SRProviderLocal absolutePath:file.path];
            if (![fileManager fileExistsAtPath:absolutePath]) {
                [SRLogger addInformation:@"Deleted file %@", file.path];
                [self.privateManagedObjectContext deleteObject:file];
            }
        }
    }
}

#pragma mark - NSFileManager helpers

- (void)readFilesForDirectory:(SRDirectory *)rootDirectory recursively:(BOOL)recursively depth:(NSInteger)depth {
    
    NSString *absolutePath = [SRProviderLocal absolutePath:rootDirectory.path];
    NSArray *files = [SRProviderLocal getFileNamesAtPath:absolutePath];
    NSString *fullPath = nil;
    for (NSString *file in files) {
        fullPath = [absolutePath stringByAppendingPathComponent:file];
        if ([SRImage fileAtPathIsImage:fullPath]) {
            
            SRImage *image = [self imageFromPath:fullPath depth:depth];
            if (![image.parent isEqual:rootDirectory]) {
                [image setParent:rootDirectory];
            }
            
        } else if ([SRDirectory fileAtPathIsDirectory:fullPath]) {
            
            SRDirectory *directory = [self directoryFromPath:fullPath recursively:recursively depth:depth];
            if (![directory.parent isEqual:rootDirectory]) {
                [directory setParent:rootDirectory];
            }
            
        } else {
            [SRLogger addError:@"Failed to read : %@", file];
        }
    }
}



@end
