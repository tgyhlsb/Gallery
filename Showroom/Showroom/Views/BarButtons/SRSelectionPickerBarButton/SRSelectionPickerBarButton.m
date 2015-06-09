//
//  SRSelectionPickerBarButton.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 08/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelectionPickerBarButton.h"

// Model
#import "SRModel.h"

// Managers
#import "SRNotificationCenter.h"

@implementation SRSelectionPickerBarButton

- (id)initWithTarget:(id)target action:(SEL)selector {
    NSString *title = [self titleForActiveSelection];
    self = [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    if (self) {
        [self registerToModelNotifications];
    }
    return self;
}

- (NSString *)titleForActiveSelection {
    SRModel *model = [SRModel defaultModel];
    if (model.activeSelection) {
        return model.activeSelection.title;
    } else {
        return NSLocalizedString(@"LOCALIZE_SELECTION_BAR_BUTTON", nil);
    }
}

#pragma mark - Notifications

- (void)registerToModelNotifications {
    [[SRNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activeSelectionDidChangerNotificationHandler)
                                                 name:SRNotificationActiveSelectionChanged
                                               object:nil];
}

- (void)activeSelectionDidChangerNotificationHandler {
    self.title = [self titleForActiveSelection];
}

@end
