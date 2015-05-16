//
//  SROperationCreateThumbnails.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SROperationCreateThumbnails.h"

// Frameworks
#import <UIKit/UIKit.h>

// Models
#import "SRImage+Serializer.h"
#import "SRImage+Helper.h"

// Managers
#import "SRLogger.h"

// Providers
#import "SRProviderLocal.h"

@interface SROperationCreateThumbnails()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *parentManagedObjectContext;

@end

@implementation SROperationCreateThumbnails

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
    [self createThumbnails];
    
    if ([self.privateManagedObjectContext hasChanges]) {
        // Save Changes
        NSError *error = nil;
        [self.privateManagedObjectContext save:&error];
    }
}

#pragma mark - Processing

- (void)createThumbnails {
    NSFetchRequest *request = [self requestForImagesWithoutThumbnail];
    
    NSError *error = nil;
    NSArray *matches = [self.privateManagedObjectContext executeFetchRequest:request error:&error];
    
    if (!error) {
        [SRLogger addInformation:@"%d missing thumbnails", matches.count];
        for (SRImage *image in matches) {
            [self createThumbnailForImage:image];
        }
    } else {
        [SRLogger addError:@"Error when fetching image with no thumbnail. Error: %@", error];
    }
}

- (void)createThumbnailForImage:(SRImage *)image {
    NSString *absolutePath = [SRProviderLocal absolutePath:image.path];
    UIImage *original = [UIImage imageWithContentsOfFile:absolutePath];
    UIImage *thumbnail = [self resizeImage:original withMaxSize:CGSizeMake(150, 150)];
    image.height = @(original.size.height);
    image.width = @(original.size.width);
    [image setImage:original];
    [image setThumbnail:thumbnail];
}

#pragma mark - Helpers

- (NSFetchRequest *)requestForImagesWithoutThumbnail {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRImage className]];
    request.predicate = [NSPredicate predicateWithFormat:@"thumbnailData = nil || imageData = nil"];
    return request;
}

- (UIImage *)resizeImage:(UIImage *)image withMaxSize:(CGSize)size {
    //    Calcul thumbnail size
    CGFloat ratio = MIN(size.width/image.size.width, size.height/image.size.height);
    CGSize targetSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    
    //    Create thumbnail
    //UIGraphicsBeginImageContext(targetSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

@end
