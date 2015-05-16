//
//  SRProviderLocal.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRProvider.h"

// Model
#import "SRDirectory.h"

@interface SRProviderLocal : SRProvider

@property (readonly, strong, nonatomic) SRDirectory *rootDirectory;

+ (SRProviderLocal *)defaultProvider;

- (BOOL)needsUpdate;

- (void)startMonitoring;
- (void)stopMonitoring;

- (void)initialize;
- (void)reloadFiles;

//- (NSString *)applicationDocumentsDirectory;
//- (NSString *)relativePath:(NSString *)path;
//- (NSString *)absolutePath:(NSString *)path;

@end
