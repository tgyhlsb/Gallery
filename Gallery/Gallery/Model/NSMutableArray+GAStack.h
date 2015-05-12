//
//  NSMutableArray+GAStack.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (GAStack)

- (void)push:(id)object;
- (id)pop;
- (id)splice;


@end
