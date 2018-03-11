//
//  SRAddSelectionBarButton.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRAddSelectionBarButton.h"

@implementation SRAddSelectionBarButton

- (id)initWithTarget:(id)target action:(SEL)selector {
    return [self initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:target action:selector];
}

@end
