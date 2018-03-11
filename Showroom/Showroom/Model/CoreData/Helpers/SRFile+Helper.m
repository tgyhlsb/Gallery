//
//  SRFile+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRFile+Helper.h"

// Providers
#import "SRProvider+Helper.h"

@implementation SRFile (Helper)

- (BOOL)isImage {
    return NO;
}

- (BOOL)isDirectory {
    return NO;
}

- (NSString *)absolutePath {
    return [SRProvider absolutePath:self.path forProviderType:self.provider];
}

- (NSString *)relativePath {
    return self.path;
}

- (NSString *)nameWithExtension:(BOOL)extension {
    if (extension) {
        return [NSString stringWithFormat:@"%@.%@", self.name, self.extension];
    } else {
        return self.name;
    }
}

@end
