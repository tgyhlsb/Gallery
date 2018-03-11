//
//  SRProvider.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

// Frameworks
#import <CoreData/CoreData.h>

static NSString *SRProviderTypeLocal = @"SRProviderTypeLocal";

@interface SRProvider : NSObject

+ (instancetype)defaultProvider;

+ (NSFetchRequest *)requestForRootDirectoryForProvider:(NSString *)provider;
+ (NSFetchRequest *)requestForFilesForProvider:(NSString *)provider;

+ (NSString *)relativePath:(NSString *)path;
+ (NSString *)absolutePath:(NSString *)path;

@end
