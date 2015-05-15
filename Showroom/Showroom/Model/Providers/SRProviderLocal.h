//
//  SRProviderLocal.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRProvider.h"

@class SRDirectory;

@interface SRProviderLocal : SRProvider

+ (SRProviderLocal *)defaultProvider;

- (SRDirectory *)readPublicDocumentDirectory;

@end
