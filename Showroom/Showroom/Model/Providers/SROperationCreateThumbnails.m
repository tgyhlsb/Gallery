//
//  SROperationCreateThumbnails.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SROperationCreateThumbnails.h"

// Models
#import "SRImage+Serializer.h"
#import "SRImage+Helper.h"

@interface SROperationCreateThumbnails()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *parentManagedObjectContext;

@end

@implementation SROperationCreateThumbnails

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
    [self createThumbnails];
    
    if ([self.privateManagedObjectContext hasChanges]) {
        // Save Changes
        NSError *error = nil;
        [self.privateManagedObjectContext save:&error];
    }
}

#pragma mark - Processing

- (void)createThumbnails {
    
}

#pragma mark - Helpers

- (NSFetchRequest *)requestForFilesForProvider:(NSString *)provider {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRFile className]];
    request.predicate = [NSPredicate predicateWithFormat:@"provider = %@", provider];
    return request;
}

@end
