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
    SRProvider *provider = nil;
    if ([providerType isEqualToString:SRProviderTypeLocal]) {
        provider = [SRProviderLocal defaultProvider];
    }
    return [provider absolutePath:path];
}

+ (NSString *)relativePath:(NSString *)path forProviderType:(NSString *)providerType {
    SRProvider *provider = nil;
    if ([providerType isEqualToString:SRProviderTypeLocal]) {
        provider = [SRProviderLocal defaultProvider];
    }
    return [provider relativePath:path];
}

@end
