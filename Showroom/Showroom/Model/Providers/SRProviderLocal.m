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

@property (strong, nonatomic) NSTimer *monitorTimer;

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
    NSString *publicDocumentsDir = [self applicationDocumentsDirectory];
    [SRLogger addInformation:@"Reading %@", publicDocumentsDir];
    self.rootDirectory = [self directoryFromPath:publicDocumentsDir recursively:YES depth:0];
    [self cleanCoreData];
    [self setLastModificationDate:self.rootDirectory.modificationDate];
    [self save];
}

#pragma mark - User defaults

#define KEY_LAST_MODIFICATION_DATE @"SRProviderLocalLastModificationDate"

- (NSDate *)lastModificationDate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KEY_LAST_MODIFICATION_DATE];
}

- (void)setLastModificationDate:(NSDate *)date {
    [[NSUserDefaults standardUserDefaults] setValue:date forKey:KEY_LAST_MODIFICATION_DATE];
}

#pragma mark - Getters & Setters

- (BOOL)needsUpdate {
    return ![self.rootDirectory.modificationDate isEqualToDate:[self lastModificationDate]];
}

#pragma mark - Factory

- (SRDirectory *)getRootDirectory {
    NSString *publicDocumentsDir = [self applicationDocumentsDirectory];
    [SRLogger addInformation:@"Reading %@", publicDocumentsDir];
    SRDirectory *rootDirectory = [self directoryFromPath:publicDocumentsDir recursively:NO depth:0];
    [self cleanCoreData];
    return rootDirectory;
}

- (SRDirectory *)fetchRootDirectoryFromCoreData {
    NSFetchRequest *request = [self requestForRootDirectoryForProvider:SRProviderTypeLocal];
    NSManagedObjectContext *context = [SRModel defaultModel].managedObjectContext;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    SRDirectory *rootDirectory = nil;
    
    if (error) {
        [SRLogger addError:@"Failed fetching local root directory. Error: '%@'", error];
    } else if (matches.count > 1) {
        [SRLogger addError:@"More than one local root directory fetched"];
        rootDirectory = [matches lastObject];
    } else {
        rootDirectory = [matches firstObject];
    }
    
    return rootDirectory;
}

- (SRDirectory *)directoryFromPath:(NSString *)path recursively:(BOOL)recursively depth:(NSInteger)depth {
    
    NSDictionary *attributes = [self getAttributesForFileAtPath:path];
    NSManagedObjectContext *context = [SRModel defaultModel].managedObjectContext;
    NSString *relativePath = [self relativePath:path];
    
    SRDirectory *rootDirectory = [SRDirectory directoryWithPath:relativePath
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
    NSString *relativePath = [self relativePath:path];
    
    return [SRImage imageWithPath:relativePath
                       attributes:attributes
                            depth:depth
                         provider:SRProviderTypeLocal
           inManagedObjectContext:context];
}

- (void)readFilesForDirectory:(SRDirectory *)rootDirectory recursively:(BOOL)recursively depth:(NSInteger)depth {
    
    NSString *absolutePath = [self absolutePath:rootDirectory.path];
    NSArray *files = [self getFileNamesAtPath:absolutePath];
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

- (void)cleanCoreData {
    
    NSFetchRequest *request = [self requestForFilesForProvider:SRProviderTypeLocal];
    NSManagedObjectContext *context = [SRModel defaultModel].managedObjectContext;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error) {
        [SRLogger addError:@"Failed fetching local root directory. Error: '%@'", error];
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (SRFile *file in matches) {
            NSString *absolutePath = [self absolutePath:file.path];
            if (![fileManager fileExistsAtPath:absolutePath]) {
                [SRLogger addInformation:@"Deleted file %@", file.path];
                [context deleteObject:file];
            }
        }
    }
}

#pragma mark - Helpers

- (void)save {
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[SRModel defaultModel] saveContext];
}

- (NSString *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.helesbeux.Showroom" in the application's documents directory.
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

- (NSString *)relativePath:(NSString *)path {
    NSInteger start = [[self applicationDocumentsDirectory] length];
    NSString *relativePath = [path substringFromIndex:start];
    return relativePath.length ? relativePath : @"/";
}

- (NSString *)absolutePath:(NSString *)path {
    NSString *absolutePath = [[self applicationDocumentsDirectory] stringByAppendingString:path];
    return absolutePath;
}

#pragma mark - Monitoring

// Dispatch queue
static dispatch_queue_t _dispatchQueue;

// A source of potential notifications
static dispatch_source_t _source;

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
        [self didMonitorChanges];
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
    [[SRNotificationCenter defaultCenter] postNotificationName:SRNotificationProviderLocalFilesDidChange object:self];
}

#pragma mark - Monitor safety

- (void)didMonitorChanges {
    [self performSelectorOnMainThread:@selector(setNotifyTimer) withObject:nil waitUntilDone:YES];
}

- (void)setNotifyTimer {
    [self.monitorTimer invalidate];
    self.monitorTimer = nil;
    self.monitorTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(monitorTimeDidEnd)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)monitorTimeDidEnd {
    self.monitorTimer = nil;
    [self filesDidChange];
}

@end
