//
//  SRSelection+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelection+Helper.h"

#import "SRLogger.h"

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

- (void)selectImage:(SRImage *)image {
    if ([self.images containsObject:image]) {
        [SRLogger addError:@"Trying to select image already selected : %@", image];
    } else {
        [self addImagesObject:image];
        self.modificationDate = [NSDate date];
    }
}

- (void)deselectImage:(SRImage *)image {
    if (![self.images containsObject:image]) {
        [SRLogger addError:@"Trying to deselect invalid image : %@", image];
    } else {
        [self removeImagesObject:image];
        self.modificationDate = [NSDate date];
    }
}

@end
