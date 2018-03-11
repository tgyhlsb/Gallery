//
//  SRSelection+Helper.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelection.h"

@interface SRSelection (Helper)

- (BOOL)isActive;
- (void)setIsActive:(BOOL)active;

- (BOOL)imageIsSelected:(SRImage *)image;
- (void)selectImage:(SRImage *)image;
- (void)deselectImage:(SRImage *)image;

@end
