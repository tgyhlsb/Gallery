//
//  GASettingsDetailDirectoryNavigation.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsDetailDirectoryNavigation.h"

@interface GASettingsDetailDirectoryNavigation ()

@end

@implementation GASettingsDetailDirectoryNavigation

+ (instancetype)new {
    GASettingsDetailDirectoryNavigation *controller = [[GASettingsDetailDirectoryNavigation alloc] initWithNibName:@"GASettingsDetailVC" bundle:nil];
    return controller;
}

#pragma mark - Configuration

- (void)initializeCellTitles {
    self.cellTitles = @[
                        @[
                            NSLocalizedString(@"LOCALIZE_SETTINGS_DIRECTORY_NAVIGATION_MODE", nil)
                            ]
                        ];
}

- (void)initializeSectionHeaders {
    self.sectionHeaders = @[
                            ];
}

- (void)initializeSectionFooters {
    self.sectionFooters = @[
                            ];
}

- (void)initializePossibleValues {
    self.possibleValues = @[
                            @[
                                @[@(GASettingDirectoryNavigationModeIgnore), @(GASettingDirectoryNavigationModeShowDirectory), @(GASettingDirectoryNavigationModeShowFirstImage)]
                                ]
                            ];
}

- (void)initializePossibleValueTitles {
    self.possibleValueTitles = @[
                                 @[
                                     @[NSLocalizedString(@"LOCALIZE_DIRECTORY_NAVIGATION_MODE_IGNORE", nil), NSLocalizedString(@"LOCALIZE_DIRECTORY_NAVIGATION_MODE_SHOW_DIRECTORY", nil), NSLocalizedString(@"LOCALIZE_DIRECTORY_NAVIGATION_MODE_SHOW_IMAGE", nil)]
                                     ]
                                 ];
}

- (void)initializeSelectedValues {
    self.selectedValues = @[
                            @[
                                @([GASettingsManager directoryNavigationMode])
                                ]
                            ];
}

- (void)initializeSelectors {
    self.selectorNames = @[
                           @[
                               @"setDirectoryNavigationMode:"
                               ]
                           ];
}

#pragma mark - Handlers

- (void)setDirectoryNavigationMode:(NSObject *)value {
    NSInteger intValue = [((NSNumber *)value) integerValue];
    [GASettingsManager setDirectoryNavigationMode:intValue];
}

@end
