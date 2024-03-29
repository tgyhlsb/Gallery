//
//  SRProvider.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRProvider.h"

// Models
#import "SRDirectory+Serializer.h"
#import "SRFile+Serializer.h"

@implementation SRProvider

#pragma mark - Abstract

+ (instancetype)defaultProvider {
    abort();
    return nil;
}

+ (NSString *)absolutePath:(NSString *)path {
    abort();
    return nil;
}

+ (NSString *)relativePath:(NSString *)path {
    abort();
    return nil;
}

#pragma mark - Requests

+ (NSFetchRequest *)requestForRootDirectoryForProvider:(NSString *)provider {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRDirectory className]];
    request.predicate = [NSPredicate predicateWithFormat:@"depth = 0 && provider = %@", provider];
    return request;
}

+ (NSFetchRequest *)requestForFilesForProvider:(NSString *)provider {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[SRFile className]];
    request.predicate = [NSPredicate predicateWithFormat:@"provider = %@", provider];
    return request;
}

@end
