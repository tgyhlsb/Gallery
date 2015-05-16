//
//  SRImage+Serializer.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImage+Serializer.h"

// Serializes
#import "SRFile+Serializer.h"

@implementation SRImage (Serializer)

+ (NSString *)className {
    return @"SRImage";
}

+ (SRImage *)imageWithPath:(NSString *)path
                attributes:(NSDictionary *)attributes
                     depth:(NSInteger)depth
                  provider:(NSString *)provider
    inManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self className]];
    request.predicate = [NSPredicate predicateWithFormat:@"path = %@", path];
    SRImage *image = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches || [matches count] > 1) {
        //handle error
    } else {
        if ([matches count]) {
            image = [matches firstObject];
            [image updateWithAttributes:attributes];
            NSLog(@"Fetched image");
        } else {
            image = [NSEntityDescription insertNewObjectForEntityForName:[self className] inManagedObjectContext:context];
            image.provider = provider;
            NSLog(@"Create image");
            [image initializeWithPath:path attributes:attributes depth:depth];
        }
    }
    
    return image;
}

@end
