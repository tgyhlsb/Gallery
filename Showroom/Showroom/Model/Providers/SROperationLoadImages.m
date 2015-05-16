//
//  SROperationLoadImages.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SROperationLoadImages.h"

// Frameworks
#import <UIKit/UIKit.h>

// Models
#import "SRImage+Serializer.h"
#import "SRImage+Helper.h"

// Managers
#import "SRLogger.h"

// Providers
#import "SRProviderLocal.h"

@interface SROperationLoadImages()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *parentManagedObjectContext;

@end

@implementation SROperationLoadImages

#pragma mark - Constructor

- (id)initWithParentManagedObjectContext:(NSManagedObjectContext *)parentManagedObjectContext {
    self= [super init];
    if (self) {
        self.queuePriority = NSOperationQueuePriorityNormal;
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
    [self loadImages];
    
    if ([self.privateManagedObjectContext hasChanges]) {
        // Save Changes
        NSError *error = nil;
        [self.privateManagedObjectContext save:&error];
    }
}

#pragma mark - Processing

- (void)loadImages {
    NSFetchRequest *request = [self requestForImagesWithoutThumbnail];
    
    NSError *error = nil;
    NSArray *matches = [self.privateManagedObjectContext executeFetchRequest:request error:&error];
    
    if (!error) {
        [SRLogger addInformation:@"%d missing images", matches.count];
        for (SRImage *image in matches) {
            [self loadImage:image];
            [self saveContext:self.privateManagedObjectContext];
        }
    } else {
        [SRLogger addError:@"Error when fetching image. Error: %@", error];
    }
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    [context save:&error];
    if (error) {
        [SRLogger addError:@"%@", error];
    }
}

- (void)loadImage:(SRImage *)image {
    NSString *absolutePath = [SRProviderLocal absolutePath:image.path];
    UIImage *original = [UIImage imageWithContentsOfFile:absolutePath];
    image.height = @(original.size.height);
    image.width = @(original.size.width);
    [image setImage:original];
}

#pragma mark - Helpers

- (NSFetchRequest *)requestForImagesWithoutThumbnail {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRImage className]];
    request.predicate = [NSPredicate predicateWithFormat:@"imageData = nil"];
    return request;
}

@end
