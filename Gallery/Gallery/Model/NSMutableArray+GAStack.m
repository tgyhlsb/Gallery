//
//  NSMutableArray+GAStack.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "NSMutableArray+GAStack.h"

@implementation NSMutableArray (GAStack)

- (void)push:(id)object {
    [self insertObject:object atIndex:0];
}

- (id)pop {
    id object = [self lastObject];
    if (object) [self removeLastObject];
    return object;
}

- (id)splice {
    return [self lastObject];
}

@end
