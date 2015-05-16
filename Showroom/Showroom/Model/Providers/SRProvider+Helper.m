//
//  SRProvider+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRProvider+Helper.h"

#import "SRProviderLocal.h"

@implementation SRProvider (Helper)

#pragma mark - Path mecanism

+ (NSString *)absolutePath:(NSString *)path forProviderType:(NSString *)providerType {
    if ([providerType isEqualToString:SRProviderTypeLocal]) {
        return [SRProviderLocal absolutePath:path];
    }
    return nil;
}

+ (NSString *)relativePath:(NSString *)path forProviderType:(NSString *)providerType {
    if ([providerType isEqualToString:SRProviderTypeLocal]) {
        return [SRProviderLocal relativePath:path];
    }
    return nil;
}

@end
