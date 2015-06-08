//
//  SRSelectionPickerBarButton.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 08/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelectionPickerBarButton.h"

@implementation SRSelectionPickerBarButton

- (id)initWithTarget:(id)target action:(SEL)selector {
    return [self initWithTitle:@"Selection" style:UIBarButtonItemStylePlain target:target action:selector];
}

@end
