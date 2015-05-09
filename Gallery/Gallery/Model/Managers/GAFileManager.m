//
//  GAFileManager.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFileManager.h"

// Managers
#import "GALogger.h"

static GAFileManager *sharedManager;

@interface GAFileManager()

@property (strong, nonatomic) GADirectory *rootDirectory;

@end

@implementation GAFileManager

#pragma mark - Singleton

+ (GAFileManager *)sharedManager {
    if (!sharedManager) sharedManager = [GAFileManager new];
    return sharedManager;
}

+ (GADirectory *)readSharedDirectory {
    return [[GAFileManager sharedManager] readSharedDirectory];
}

+ (GADirectory *)rootDirectory {
    return [[GAFileManager sharedManager] rootDirectory];
}

+ (void)readSharedDirectoryInBackgroundWithBlock:(GAFileReadingCompletionBlock)block {
    [[GAFileManager sharedManager] readSharedDirectoryInBackgroundWithBlock:block];
}

+ (void)startMonitoring {
    [[GAFileManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring {
    [[GAFileManager sharedManager] stopMonitoring];
}

#pragma mark - Getters & Setters

- (GADirectory *)rootDirectory {
    if (!_rootDirectory) {
        _rootDirectory = [self readSharedDirectory];
    }
    return _rootDirectory;
}

#pragma mark - Methods

- (GADirectory *)readSharedDirectory {
    self.rootDirectory = [self generateTree];
    return self.rootDirectory;
}

- (void)readSharedDirectoryInBackgroundWithBlock:(GAFileReadingCompletionBlock)block {
    [self generateTreeInBackgroundWithBlock:^(GADirectory *root, NSError *error) {
        self.rootDirectory = root;
        if (block) block(root, nil);
    }];
}

- (GADirectory *)generateTree {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = [paths objectAtIndex:0];
    [GALogger addInformation:@"%@", publicDocumentsDir];
    return [GADirectory directoryFromPath:publicDocumentsDir parent:nil];
}

// Reference http://stackoverflow.com/questions/16283652/understanding-dispatch-async

- (void)generateTreeInBackgroundWithBlock:(GAFileReadingCompletionBlock)block {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GADirectory *root = [self generateTree];
        if (block) {
            block(root, nil);
        }
    });
}

#pragma mark - Monitoring


// Dispatch queue
static dispatch_queue_t _dispatchQueue;

// A source of potential notifications
static dispatch_source_t _source;

- (void)startMonitoring {
#define fileChangedNotification @"fileChangedNotification"
    
    // Get the path to the home directory
    NSString * homeDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
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
        [GALogger addInformation:@"File directory changed"];
        self.rootDirectory = [self generateTree];
        // We call an NSNotification so the file can change can be detected anywhere
        [[NSNotificationCenter defaultCenter] postNotificationName:GANotificationFileDirectoryChanged object:Nil];
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

@end
