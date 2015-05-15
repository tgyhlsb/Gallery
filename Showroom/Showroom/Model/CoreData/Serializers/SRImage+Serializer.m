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
        } else {
            image = [NSEntityDescription insertNewObjectForEntityForName:[self className] inManagedObjectContext:context];
        }
        
        //TODO attributes
        image.provider = provider;
        [image updateWithPath:path attributes:attributes];
    }
    
    return image;
}

@end
