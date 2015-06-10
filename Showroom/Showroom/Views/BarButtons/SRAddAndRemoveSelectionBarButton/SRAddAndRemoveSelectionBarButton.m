//
//  SRAddAndRemoveSelectionBarButton.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRAddAndRemoveSelectionBarButton.h"

@implementation SRAddAndRemoveSelectionBarButton

- (id)initWithTarget:(id)target action:(SEL)selector selected:(BOOL)selected {
    NSString *title = [self titleForSelected:selected];
    self = [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    if (self) {
        
    }
    return self;
}

- (NSString *)titleForSelected:(BOOL)selected {
    return selected ? @"-" : @"+";
}

#pragma mark - Getters & Setters

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.title = [self titleForSelected:selected];
}

@end
