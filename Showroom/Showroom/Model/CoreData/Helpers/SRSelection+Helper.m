//
//  SRSelection+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelection+Helper.h"

@implementation SRSelection (Helper)

- (BOOL)isActive {
    return [self.active boolValue];
}

- (void)setIsActive:(BOOL)active {
    self.active = @(active);
}

- (BOOL)imageIsSelected:(SRImage *)image {
    return [self.images containsObject:image];
}

@end
