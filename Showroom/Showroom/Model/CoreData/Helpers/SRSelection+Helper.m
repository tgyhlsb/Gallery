//
//  SRSelection+Helper.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelection+Helper.h"

@implementation SRSelection (Helper)

- (BOOL)isSelected {
    return [self.selected boolValue];
}

- (void)setIsSelected:(BOOL)selected {
    self.selected = @(selected);
}

@end
