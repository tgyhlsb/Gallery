//
//  SRProviderLocal.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRProviderLocal.h"

// Managers
#import "SRNotificationCenter.h"
#import "SRLogger.h"

// Models
#import "SRModel.h"
#import "SRDirectory+Serializer.h"
#import "SRImage+Serializer.h"
#import "SRFile+Helper.h"
#import "SRImage+Helper.h"
#import "SRDirectory+Helper.h"

@interface SRProviderLocal()

@property (readwrite, strong, nonatomic) SRDirectory *rootDirectory;

@end

@implementation SRProviderLocal

#pragma mark - Singleton

static SRProviderLocal *defaultProvider;

+ (SRProviderLocal *)defaultProvider {
    if (!defaultProvider) {
        defaultProvider = [[SRProviderLocal alloc] init];
    }
    return defaultProvider;
}

#pragma mark - Configuration

- (void)initialize {
    self.rootDirectory = [self getRootDirectory];
}

- (void)reloadFiles {
    [self readFilesForDirectory:self.rootDirectory recursively:YES depth:1];
}

#pragma mark - Factory

- (SRDirectory *)getRootDirectory {
    NSString *publicDocumentsDir = [self applicationDocumentsDirectory];
    [SRLogger addInformation:@"Reading %@", publicDocumentsDir];
    SRDirectory *rootDirectory = [self directoryFromPath:publicDocumentsDir recursively:NO depth:0];
    return rootDirectory;
}

- (SRDirectory *)directoryFromPath:(NSString *)path recursively:(BOOL)recursively depth:(NSInteger)depth {
    
    NSDictionary *attributes = [self getAttributesForFileAtPath:path];
    NSManagedObjectContext *context = [SRModel defaultModel].managedObjectContext;
    
    SRDirectory *rootDirectory = [SRDirectory directoryWithPath:path
                                                     attributes:attributes
                                                          depth:depth
                                                       provider:SRProviderTypeLocal
                                         inManagedObjectContext:context];
    
    if (recursively) {
        [self readFilesForDirectory:rootDirectory recursively:(BOOL)recursively depth:depth+1];
    }
    
    return rootDirectory;
}

- (SRImage *)imageFromPath:(NSString *)path depth:(NSInteger)depth {
    
    NSDictionary *attributes = [self getAttributesForFileAtPath:path];
    NSManagedObjectContext *context = [SRModel defaultModel].managedObjectContext;
    
    return [SRImage imageWithPath:path attributes:attributes
                            depth:depth
                         provider:SRProviderTypeLocal
           inManagedObjectContext:context];
}

- (void)readFilesForDirectory:(SRDirectory *)rootDirectory recursively:(BOOL)recursively depth:(NSInteger)depth {
    
    NSArray *files = [self getFileNamesAtPath:rootDirectory.path];
    NSString *fullPath = nil;
    
    for (NSString *file in files) {
        fullPath = [rootDirectory.path stringByAppendingPathComponent:file];
        if ([SRImage fileAtPathIsImage:fullPath]) {
            
            SRImage *image = [self imageFromPath:fullPath depth:depth];
            [image setParent:rootDirectory];
            
        } else if ([SRDirectory fileAtPathIsDirectory:fullPath]) {
            
            SRDirectory *directory = [self directoryFromPath:fullPath recursively:recursively depth:depth];
            [directory setParent:rootDirectory];
            
        } else {
            [SRLogger addError:@"Failed to read : %@", file];
        }
    }
}

- (NSArray *)getFileNamesAtPath:(NSString *)path {
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        [SRLogger addError:@"Error reading contents of documents directory: %@", error];
    }
    return files;
}

- (NSDictionary *)getAttributesForFileAtPath:(NSString *)path {
    NSError *error;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        [SRLogger addError:@"Error reading attributes of documents directory: %@", error];
    }
    return attributes;
}

#pragma mark - Monitoring

// Dispatch queue
static dispatch_queue_t _dispatchQueue;

// A source of potential notifications
static dispatch_source_t _source;


- (NSString *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.helesbeux.Showroom" in the application's documents directory.
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (void)startMonitoring {
    
    // Get the path to the home directory
    NSString * homeDirectory = [self applicationDocumentsDirectory];
    
    // Create a new file descriptor - we need to convert the NSString to a char * i.e. C style string
    int filedes = open([homeDirectory cStringUsingEncoding:NSASCIIStringEncoding], O_EVTONLY);
    
    // Create a dispatch queue - when a file changes the event will be sent to this queue
    _dispatchQueue = dispatch_queue_create("FileMonitorQueue", 0);
    
    // Create a GCD source. This will monitor the file descriptor to see if a write command is detected
    // The following options are available
    
    /*!
     * @typedef dispatch_source_vnode_flags_t
     * Type of dispatch_source_vnode flags
     *
     * @constant DISPATCH_VNODE_DELETE
     * The filesystem object was deleted from the namespace.
     *
     * @constant DISPATCH_VNODE_WRITE
     * The filesystem object data changed.
     *
     * @constant DISPATCH_VNODE_EXTEND
     * The filesystem object changed in size.
     *
     * @constant DISPATCH_VNODE_ATTRIB
     * The filesystem object metadata changed.
     *
     * @constant DISPATCH_VNODE_LINK
     * The filesystem object link count changed.
     *
     * @constant DISPATCH_VNODE_RENAME
     * The filesystem object was renamed in the namespace.
     *
     * @constant DISPATCH_VNODE_REVOKE
     * The filesystem object was revoked.
     */
    
    // Write covers - adding a file, renaming a file and deleting a file...
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,filedes,
                                     DISPATCH_VNODE_WRITE,
                                     _dispatchQueue);
    
    
    // This block will be called when teh file changes
    dispatch_source_set_event_handler(_source, ^(){
        [self filesDidChange];
    });
    
    // When we stop monitoring the file this will be called and it will close the file descriptor
    dispatch_source_set_cancel_handler(_source, ^() {
        close(filedes);
    });
    
    // Start monitoring the file...
    dispatch_resume(_source);
    
    //...
    
    // When we want to stop monitoring the file we call this
    //dispatch_source_cancel(_source);
    
}

- (void)stopMonitoring {
    // When we want to stop monitoring the file we call this
    dispatch_source_cancel(_source);
}

- (void)filesDidChange {
    [self stopMonitoring];
}

@end
