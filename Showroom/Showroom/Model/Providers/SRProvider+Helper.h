//
//  SRProvider+Helper.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRProvider.h"

@interface SRProvider (Helper)

+ (NSString *)relativePath:(NSString *)path forProviderType:(NSString *)providerType;
+ (NSString *)absolutePath:(NSString *)path forProviderType:(NSString *)providerType;

@end
