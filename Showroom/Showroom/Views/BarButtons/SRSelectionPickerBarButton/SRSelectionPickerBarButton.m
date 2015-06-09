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
    NSString *title = NSLocalizedString(@"LOCALIZE_SELECTION_BAR_BUTTON", nil);
    return [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
}

@end
