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

- (NSFetchRequest *)requestForRootDirectoryForProvider:(NSString *)provider;

@end
