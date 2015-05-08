//
//  GAFile+Pointers.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAFile+Pointers.h"

@implementation GAFile (Pointers)

- (GAImageFile *)nextImage {
    GAFile *next = self.next;
    while (!next.isImage) {
        next = next.next;
    }
    return (GAImageFile *)next;
}

- (GAImageFile *)previousImage {
    GAFile *previous = self.previous;
    while (!previous.isImage) {
        previous = previous.previous;
    }
    return (GAImageFile *)previous;
}

- (GADirectory *)nextDirectory {
    GAFile *next = self.next;
    while (!next.isDirectory) {
        next = next.next;
    }
    return (GADirectory *)next;
}

- (GADirectory *)previousDirectory {
    GAFile *previous = self.previous;
    while (!previous.isDirectory) {
        previous = previous.previous;
    }
    return (GADirectory *)previous;
}

@end
