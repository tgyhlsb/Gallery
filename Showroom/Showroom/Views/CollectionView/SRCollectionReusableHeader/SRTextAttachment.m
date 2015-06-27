//
//  SRTextAttachment.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 27/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTextAttachment.h"

@implementation SRTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    CGRect bounds;
    bounds.origin = CGPointMake(0, -5);
    bounds.size = self.image.size;
    return bounds;
}

@end
