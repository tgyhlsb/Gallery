//
//  SRSelectionPickerBarButton.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 08/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelectionPickerBarButton.h"

@implementation SRSelectionPickerBarButton

- (id)initWithTarget:(id)target action:(SEL)selector selection:(SRSelection *)selection {
    NSString *title = [self titleForSelection:selection];
    self = [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    if (self) {
        _selection = selection;
    }
    return self;
}

- (NSString *)titleForSelection:(SRSelection *)selection {
    if (selection) {
        return selection.title;
    } else {
        return NSLocalizedString(@"LOCALIZE_SELECTION_BAR_BUTTON", nil);
    }
}

#pragma mark - Getters & Setters

- (void)setSelection:(SRSelection *)selection {
    _selection = selection;
    self.title = [self titleForSelection:selection];
}

@end
